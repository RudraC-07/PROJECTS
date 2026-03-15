"use client";
import { useState, useEffect, use } from "react";
import Link from "next/link";
import {
  ArrowLeft,
  Briefcase,
  Calendar,
  TrendingDown,
  TrendingUp,
  Wallet,
  Clock,
  ChevronRight,
} from "lucide-react";
import { Card } from "@/components/ui/Card";
import { Button } from "@/components/ui/Button";
interface Project {
  projectid: number;
  projectname: string;
  projectdetail?: string;
  description?: string;
  projectstartdate?: string;
}
interface Transaction {
  type: "expense" | "income";
  amount: number | string;
  date: string;
  expensedetail?: string;
  incomedetail?: string;
  categories?: {
    categoryname: string;
  };
  projectid?: number;
}
export default function ProjectDetailsPage({
  params,
}: {
  params: Promise<{
    id: string;
  }>;
}) {
  const { id } = use(params);
  const [project, setProject] = useState<Project | null>(null);
  const [transactions, setTransactions] = useState<Transaction[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  useEffect(() => {
    const fetchProjectDetails = async () => {
      try {
        setLoading(true);
        const projectRes = await fetch(`/api/projects?id=${id}`);
        const projectData = await projectRes.json();
        if (!projectRes.ok) {
          setError("Project not found");
          return;
        }
        setProject(projectData);
        const [expRes, incRes] = await Promise.all([
          fetch("/api/expenses"),
          fetch("/api/incomes"),
        ]);
        const expenses: Transaction[] = await expRes.json();
        const incomes: Transaction[] = await incRes.json();
        const projectExpenses = expenses.filter(
          (e) => e.projectid?.toString() === id,
        );
        const projectIncomes = incomes.filter(
          (i) => i.projectid?.toString() === id,
        );
        const merged = [
          ...projectExpenses.map((e) => ({
            ...e,
            type: "expense" as const,
            date: (e as any).expensedate,
          })),
          ...projectIncomes.map((i) => ({
            ...i,
            type: "income" as const,
            date: (i as any).incomedate,
          })),
        ].sort(
          (a, b) => new Date(b.date).getTime() - new Date(a.date).getTime(),
        );
        setTransactions(merged);
      } catch (err) {
        console.error(err);
        setError("Failed to load project details");
      } finally {
        setLoading(false);
      }
    };
    fetchProjectDetails();
  }, [id]);
  if (loading) {
    return (
      <div className="flex flex-col items-center justify-center min-h-[60vh]">
        <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-primary"></div>
        <p className="mt-4 text-muted-foreground font-medium">
          Loading project details...
        </p>
      </div>
    );
  }
  if (error || !project) {
    return (
      <div className="flex flex-col items-center justify-center min-h-[60vh] space-y-4">
        <div className="h-16 w-16 rounded-full bg-rose-500/10 flex items-center justify-center text-rose-500">
          <Briefcase className="h-8 w-8" />
        </div>
        <h2 className="text-xl font-semibold">
          {error || "Project Not Found"}
        </h2>
        <Link href="/admin/projects">
          <Button variant="outline">Back to Projects</Button>
        </Link>
      </div>
    );
  }
  const totalExpenses = transactions
    .filter((t) => t.type === "expense")
    .reduce((sum, t) => sum + Number(t.amount), 0);
  const totalIncome = transactions
    .filter((t) => t.type === "income")
    .reduce((sum, t) => sum + Number(t.amount), 0);
  const balance = totalIncome - totalExpenses;
  return (
    <div className="space-y-8">
      {}
      <div className="flex flex-col md:flex-row md:items-center justify-between gap-4">
        <div className="flex items-center gap-4">
          <Link href="/admin/projects">
            <Button
              variant="ghost"
              size="icon"
              className="rounded-full h-10 w-10 hover:bg-primary/10 hover:text-primary"
            >
              <ArrowLeft className="h-5 w-5" />
            </Button>
          </Link>
          <div>
            <div className="flex items-center gap-2 mb-1">
              <span className="text-[10px] font-medium uppercase tracking-[0.2em] text-primary/60">
                Project Details
              </span>
              <ChevronRight className="h-3 w-3 text-muted-foreground" />
              <span className="text-[10px] font-medium uppercase tracking-[0.2em] text-muted-foreground">
                {project.projectname}
              </span>
            </div>
            <h1 className="text-3xl font-semibold tracking-tight text-foreground uppercase">
              {project.projectname}
            </h1>
          </div>
        </div>
        <div className="flex items-center gap-2">
          <Link href="/admin/expenses/add">
            <Button
              variant="outline"
              size="sm"
              className="rounded-xl border-primary/20 text-primary hover:bg-primary/5"
            >
              Add Expense
            </Button>
          </Link>
          <Link href="/admin/incomes/add">
            <Button
              size="sm"
              className="rounded-xl shadow-lg shadow-primary/20"
            >
              Add Income
            </Button>
          </Link>
        </div>
      </div>
      {}
      <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
        <Card className="lg:col-span-1 border-primary/10">
          <div className="flex items-center gap-3 mb-6">
            <div className="h-10 w-10 rounded-xl bg-primary/10 flex items-center justify-center text-primary">
              <Briefcase className="h-5 w-5" />
            </div>
            <h3 className="font-semibold text-lg">About Project</h3>
          </div>
          <div className="space-y-4">
            <div>
              <p className="text-[10px] font-medium text-muted-foreground uppercase tracking-widest mb-1">
                Description
              </p>
              <p className="text-sm text-foreground/80 leading-relaxed">
                {project.projectdetail ||
                  project.description ||
                  "No detailed description provided for this project."}
              </p>
            </div>
            <div className="grid grid-cols-2 gap-4 pt-4 border-t border-border">
              <div>
                <p className="text-[10px] font-medium text-muted-foreground uppercase tracking-widest mb-1">
                  Start Date
                </p>
                <div className="flex items-center gap-2 text-sm font-semibold">
                  <Calendar className="h-4 w-4 text-primary" />
                  {project.projectstartdate
                    ? new Date(project.projectstartdate).toLocaleDateString(
                        "en-GB",
                      )
                    : "Not set"}
                </div>
              </div>
              <div>
                <p className="text-[10px] font-medium text-muted-foreground uppercase tracking-widest mb-1">
                  Status
                </p>
                <div className="flex items-center gap-2">
                  <span className="h-2 w-2 rounded-full bg-emerald-500 animate-pulse"></span>
                  <span className="text-sm font-medium text-emerald-500 uppercase tracking-tighter">
                    Active
                  </span>
                </div>
              </div>
            </div>
          </div>
        </Card>
        <div className="lg:col-span-2 grid grid-cols-1 md:grid-cols-3 gap-4">
          <Card className="border-t-4 border-t-emerald-500 bg-emerald-500/[0.02]">
            <div className="flex items-center justify-between mb-4">
              <div className="p-2 rounded-lg bg-emerald-500/10 text-emerald-600">
                <TrendingUp className="h-5 w-5" />
              </div>
              <span className="text-[9px] font-semibold text-emerald-600/50 uppercase tracking-widest">
                Revenue
              </span>
            </div>
            <p className="text-2xl font-semibold text-emerald-600 tracking-tight">
              $
              {totalIncome.toLocaleString(undefined, {
                minimumFractionDigits: 2,
              })}
            </p>
            <p className="text-[10px] text-muted-foreground mt-1 font-medium italic">
              Total project funding
            </p>
          </Card>
          <Card className="border-t-4 border-t-rose-500 bg-rose-500/[0.02]">
            <div className="flex items-center justify-between mb-4">
              <div className="p-2 rounded-lg bg-rose-500/10 text-rose-600">
                <TrendingDown className="h-5 w-5" />
              </div>
              <span className="text-[9px] font-medium text-rose-600/50 uppercase tracking-widest">
                Expenses
              </span>
            </div>
            <p className="text-2xl font-semibold text-rose-600 tracking-tight">
              $
              {totalExpenses.toLocaleString(undefined, {
                minimumFractionDigits: 2,
              })}
            </p>
            <p className="text-[10px] text-muted-foreground mt-1 font-medium italic">
              Costs incurred
            </p>
          </Card>
          <Card className="border-t-4 border-t-primary bg-primary/[0.02]">
            <div className="flex items-center justify-between mb-4">
              <div className="p-2 rounded-lg bg-primary/10 text-primary">
                <Wallet className="h-5 w-5" />
              </div>
              <span className="text-[9px] font-semibold text-primary/50 uppercase tracking-widest">
                Net Profit
              </span>
            </div>
            <p
              className={`text-2xl font-black tracking-tight ${balance >= 0 ? "text-primary" : "text-rose-500"}`}
            >
              $
              {balance.toLocaleString(undefined, {
                minimumFractionDigits: 2,
              })}
            </p>
            <p className="text-[10px] text-muted-foreground mt-1 font-medium italic">
              Current standing
            </p>
          </Card>
        </div>
      </div>
      {}
      <Card
        title="Project Transactions"
        subtitle="Complete history of income and expenses"
        className="overflow-hidden"
      >
        {transactions.length > 0 ? (
          <div className="mt-4 -mx-5 overflow-x-auto">
            <table className="w-full text-left border-collapse">
              <thead>
                <tr className="bg-secondary/20 border-y border-border">
                  <th className="px-6 py-4 text-[10px] font-medium uppercase tracking-widest text-muted-foreground">
                    Type
                  </th>
                  <th className="px-6 py-4 text-[10px] font-medium uppercase tracking-widest text-muted-foreground">
                    Detail
                  </th>
                  <th className="px-6 py-4 text-[10px] font-medium uppercase tracking-widest text-muted-foreground">
                    Date
                  </th>
                  <th className="px-6 py-4 text-[10px] font-medium uppercase tracking-widest text-muted-foreground text-right">
                    Amount
                  </th>
                </tr>
              </thead>
              <tbody className="divide-y divide-border">
                {transactions.map((tx, idx) => (
                  <tr key={idx} className="hover:bg-primary/[0.02] group">
                    <td className="px-6 py-4">
                      <span
                        className={`inline-flex items-center gap-1.5 px-2.5 py-1 rounded-full text-[9px] font-medium uppercase tracking-tighter border ${
                          tx.type === "income"
                            ? "bg-emerald-500/10 text-emerald-600 border-emerald-500/20"
                            : "bg-rose-500/10 text-rose-600 border-rose-500/20"
                        }`}
                      >
                        {tx.type === "income" ? (
                          <TrendingUp className="h-3 w-3" />
                        ) : (
                          <TrendingDown className="h-3 w-3" />
                        )}
                        {tx.type}
                      </span>
                    </td>
                    <td className="px-6 py-4">
                      <p className="font-medium text-sm text-foreground/90 group-hover:text-primary">
                        {tx.expensedetail || tx.incomedetail || "Transaction"}
                      </p>
                      {tx.categories?.categoryname && (
                        <p className="text-[9px] font-medium text-muted-foreground uppercase tracking-widest mt-0.5">
                          {tx.categories.categoryname}
                        </p>
                      )}
                    </td>
                    <td className="px-6 py-4">
                      <div className="flex items-center gap-2 text-muted-foreground font-medium text-xs">
                        <Clock className="h-3 w-3" />
                        {new Date(tx.date).toLocaleDateString("en-GB")}
                      </div>
                    </td>
                    <td
                      className={`px-6 py-4 text-right font-black text-sm ${
                        tx.type === "income"
                          ? "text-emerald-500"
                          : "text-rose-500"
                      }`}
                    >
                      {tx.type === "income" ? "+" : "-"}$
                      {Number(tx.amount).toLocaleString(undefined, {
                        minimumFractionDigits: 2,
                      })}
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        ) : (
          <div className="h-64 flex flex-col items-center justify-center border-2 border-dashed border-border rounded-3xl bg-secondary/5 mt-4">
            <div className="p-3 rounded-full bg-muted/50 mb-3">
              <Wallet className="h-6 w-6 text-muted-foreground/30" />
            </div>
            <p className="text-[10px] font-medium text-muted-foreground uppercase tracking-widest">
              No transactions recorded for this project
            </p>
          </div>
        )}
      </Card>
    </div>
  );
}