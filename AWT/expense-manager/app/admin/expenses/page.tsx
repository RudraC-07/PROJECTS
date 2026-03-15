"use client";
import { useState, useEffect } from "react";
import { Card } from "@/components/ui/Card";
import { Button } from "@/components/ui/Button";
import { ConfirmModal } from "@/components/ui/ConfirmModal";
import Link from "next/link";
import { Plus, Search, Filter, TrendingDown, Trash2 } from "lucide-react";
export default function ExpensesListPage() {
  const [expenses, setExpenses] = useState([]);
  const [loading, setLoading] = useState(true);
  const [deleteModal, setDeleteModal] = useState({ isOpen: false, id: 0 });
  useEffect(() => {
    fetchExpenses();
  }, []);
  const fetchExpenses = async () => {
    try {
      const res = await fetch("/api/expenses");
      const data = await res.json();
      if (res.ok) setExpenses(data);
    } catch (err) {
      console.error(err);
    } finally {
      setLoading(false);
    }
  };
  const handleDelete = async () => {
    const { id } = deleteModal;
    try {
      const res = await fetch(`/api/expenses?id=${id}`, {
        method: "DELETE",
      });
      if (res.ok) {
        setExpenses(expenses.filter((ex: any) => ex.expenseid !== id));
      } else {
        const data = await res.json();
        alert(data.message || "Failed to delete expense");
      }
    } catch (err) {
      console.error(err);
      alert("An error occurred while deleting");
    }
  };
  return (
    <div className="space-y-6">
      <div className="flex justify-between items-center">
        <div>
          <h1 className="text-2xl font-semibold tracking-tight text-rose-600">
            Project Expenses
          </h1>
          <p className="text-muted-foreground mt-1">
            Full history of all project-related expenses.
          </p>
        </div>
        <Link href="/admin/expenses/add">
          <Button className="font-medium shadow-md bg-rose-600 hover:bg-rose-700 text-white">
            <Plus className="mr-2 h-4 w-4" /> Add Expense
          </Button>
        </Link>
      </div>
      <div className="grid grid-cols-1 md:grid-cols-4 gap-4 mb-6">
        <div className="relative col-span-2">
          <Search className="absolute left-3 top-2.5 h-4 w-4 text-muted-foreground" />
          <input
            type="text"
            placeholder="Search by detail or project..."
            className="pl-10 h-10 w-full rounded-md border border-input bg-card px-3 py-2 text-sm focus-visible:outline-none focus-visible:ring-1 focus-visible:ring-rose-500/40"
          />
        </div>
        <Button variant="outline" className="flex items-center gap-2">
          <Filter className="h-4 w-4" /> Filter
        </Button>
        <Button variant="outline">Export Data</Button>
      </div>
      <Card className="shadow-lg border-rose-500/20 border-t-4 border-t-rose-500 overflow-hidden">
        {loading ? (
          <div className="py-20 text-center text-muted-foreground">
            <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-rose-500 mx-auto mb-4"></div>
            Loading expenses...
          </div>
        ) : expenses.length > 0 ? (
          <div className="overflow-x-auto">
            <table className="w-full text-left text-sm border-collapse">
              <thead>
                <tr className="border-b border-border text-muted-foreground uppercase text-[10px] tracking-wider font-semibold bg-rose-500/5">
                  <th className="px-6 py-4">Date</th>
                  <th className="px-6 py-4">Detail & Project</th>
                  <th className="px-6 py-4">Category</th>
                  <th className="px-6 py-4 text-right">Amount</th>
                  <th className="px-6 py-4 text-center w-20">Actions</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-border">
                {expenses.map((ex: any) => (
                  <tr
                    key={ex.expenseid}
                    className="hover:bg-rose-500/[0.02] group"
                  >
                    <td className="px-6 py-4 text-muted-foreground font-medium">
                      {new Date(ex.expensedate).toLocaleDateString("en-GB")}
                    </td>
                    <td className="px-6 py-4">
                      <p className="font-medium text-foreground">
                        {ex.expensedetail || "Unspecified Detail"}
                      </p>
                      <p className="text-[10px] text-rose-600 font-semibold uppercase tracking-tight">
                        {ex.projects?.projectname || "General"}
                      </p>
                    </td>
                    <td className="px-6 py-4">
                      <span className="inline-flex items-center rounded-lg px-2 py-1 text-[10px] font-semibold uppercase bg-rose-500/10 text-rose-600 border border-rose-500/20">
                        {ex.categories?.categoryname || "Miscellaneous"}
                      </span>
                    </td>
                    <td className="px-6 py-4 text-right font-medium text-rose-600 text-sm">
                      -$
                      {Number(ex.amount).toLocaleString(undefined, {
                        minimumFractionDigits: 2,
                      })}
                    </td>
                    <td className="px-6 py-4">
                      <div className="flex justify-center">
                        <button
                          onClick={() =>
                            setDeleteModal({ isOpen: true, id: ex.expenseid })
                          }
                          className="p-2 text-rose-500 hover:bg-rose-500/10 rounded-xl border border-transparent hover:border-rose-500/20 shadow-sm bg-background"
                          title="Delete Record"
                        >
                          <Trash2 className="h-4 w-4" />
                        </button>
                      </div>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        ) : (
          <div className="py-20 text-center text-muted-foreground border-2 border-dashed rounded-xl bg-secondary/5 m-6">
            <div className="h-12 w-12 rounded-full bg-rose-500/10 flex items-center justify-center mx-auto mb-4">
              <TrendingDown className="h-6 w-6 text-rose-600" />
            </div>
            <p className="font-medium uppercase text-[10px] tracking-widest">
              No expenses recorded yet
            </p>
            <Link
              href="/admin/expenses/add"
              className="mt-4 inline-block text-rose-600 font-medium hover:underline uppercase text-[10px] tracking-widest"
            >
              Record your first expense
            </Link>
          </div>
        )}
      </Card>
      <ConfirmModal
        isOpen={deleteModal.isOpen}
        onClose={() => setDeleteModal({ ...deleteModal, isOpen: false })}
        onConfirm={handleDelete}
        title="Delete Expense"
        message="Are you sure you want to permanently delete this expense record? This action cannot be undone."
      />
    </div>
  );
}