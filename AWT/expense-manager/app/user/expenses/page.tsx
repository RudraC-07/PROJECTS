"use client";
import { useState, useEffect } from "react";
import { Card } from "@/components/ui/Card";
import { Button } from "@/components/ui/Button";
import { ConfirmModal } from "@/components/ui/ConfirmModal";
import Link from "next/link";
import { Plus, Trash2, Clock, Wallet } from "lucide-react";
export default function UserExpensesListPage() {
  const [expenses, setExpenses] = useState([]);
  const [loading, setLoading] = useState(true);
  const [deleteModal, setDeleteModal] = useState({
    isOpen: false,
    id: 0,
  });
  useEffect(() => {
    fetchExpenses();
  }, []);
  const fetchExpenses = async () => {
    try {
      setLoading(true);
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
      {" "}
      <div className="flex justify-between items-center">
        {" "}
        <div>
          {" "}
          <h1 className="text-2xl font-semibold tracking-tight text-rose-600">
            My Project Expenses
          </h1>{" "}
          <p className="text-muted-foreground mt-1">
            Review all your personal project-related expenses.
          </p>{" "}
        </div>{" "}
        <Link href="/user/expenses/add">
          {" "}
          <Button className="font-medium shadow-md bg-rose-600 hover:bg-rose-700 text-white rounded-xl px-6">
            {" "}
            <Plus className="mr-2 h-4 w-4" />
            Add Expense{" "}
          </Button>{" "}
        </Link>{" "}
      </div>{" "}
      <Card className="shadow-lg border-rose-500/20 overflow-hidden">
        {" "}
        {loading ? (
          <div className="py-20 text-center text-muted-foreground">
            {" "}
            <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-rose-500 mx-auto mb-4"></div>{" "}
            Loading your expenses...{" "}
          </div>
        ) : expenses.length > 0 ? (
          <div className="overflow-x-auto -mx-5">
            {" "}
            <table className="w-full text-left text-sm border-collapse">
              {" "}
              <thead>
                {" "}
                <tr className="border-y border-border text-muted-foreground uppercase text-[10px] tracking-wider font-semibold bg-rose-500/5">
                  {" "}
                  <th className="px-6 py-4">Date</th>{" "}
                  <th className="px-6 py-4">Detail & Project</th>{" "}
                  <th className="px-6 py-4 text-right">Amount</th>{" "}
                  <th className="px-6 py-4 text-center w-24">Actions</th>{" "}
                </tr>{" "}
              </thead>{" "}
              <tbody className="divide-y divide-border">
                {" "}
                {expenses.map((ex: any) => (
                  <tr
                    key={ex.expenseid}
                    className="hover:bg-rose-500/[0.02] group"
                  >
                    {" "}
                    <td className="px-6 py-4 text-muted-foreground font-medium">
                      {" "}
                      <div className="flex items-center gap-2">
                        {" "}
                        <Clock className="h-3 w-3" />{" "}
                        {new Date(ex.expensedate).toLocaleDateString(
                          "en-GB",
                        )}{" "}
                      </div>{" "}
                    </td>{" "}
                    <td className="px-6 py-4">
                      {" "}
                      <p className="font-medium text-foreground">
                        {ex.expensedetail || "Expense"}
                      </p>{" "}
                      <p className="text-[10px] text-rose-600 font-semibold uppercase tracking-tight">
                        {ex.projects?.projectname || "General"}
                      </p>{" "}
                    </td>{" "}
                    <td className="px-6 py-4 text-right font-medium text-rose-600 text-sm">
                      {" "}
                      -${Number(ex.amount).toFixed(2)}{" "}
                    </td>{" "}
                    <td className="px-6 py-4">
                      {" "}
                      <div className="flex justify-center">
                        {" "}
                        <button
                          onClick={() =>
                            setDeleteModal({
                              isOpen: true,
                              id: ex.expenseid,
                            })
                          }
                          className="p-2 text-rose-500 hover:bg-rose-500/10 rounded-xl border border-transparent hover:border-rose-500/20 shadow-sm bg-background"
                          title="Delete Record"
                        >
                          {" "}
                          <Trash2 className="h-4 w-4" />{" "}
                        </button>{" "}
                      </div>{" "}
                    </td>{" "}
                  </tr>
                ))}{" "}
              </tbody>{" "}
            </table>{" "}
          </div>
        ) : (
          <div className="py-20 text-center text-muted-foreground border-2 border-dashed rounded-3xl bg-secondary/5 m-6">
            {" "}
            <div className="h-12 w-12 rounded-full bg-rose-500/10 flex items-center justify-center mx-auto mb-4">
              {" "}
              <Wallet className="h-6 w-6 text-rose-600" />{" "}
            </div>{" "}
            <p className="text-[10px] font-semibold uppercase tracking-[0.2em]">
              No expenses recorded yet
            </p>{" "}
            <Link
              href="/user/expenses/add"
              className="mt-4 inline-block text-rose-600 font-semibold hover:underline uppercase text-[10px] tracking-widest opacity-70 hover:opacity-100"
            >
              {" "}
              Add your first record{" "}
            </Link>{" "}
          </div>
        )}{" "}
      </Card>{" "}
      <ConfirmModal
        isOpen={deleteModal.isOpen}
        onClose={() =>
          setDeleteModal({
            ...deleteModal,
            isOpen: false,
          })
        }
        onConfirm={handleDelete}
        title="Delete Record"
        message="Are you sure you want to delete this expense? This will permanently remove it from your project history."
      />{" "}
    </div>
  );
}