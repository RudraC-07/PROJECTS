'use client';

import { useState, useEffect } from 'react';
import { Card } from '@/components/ui/Card';
import { Button } from '@/components/ui/Button';
import Link from 'next/link';
import { Plus } from 'lucide-react';

export default function UserExpensesListPage() {
  const [expenses, setExpenses] = useState([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    fetchExpenses();
  }, []);

  const fetchExpenses = async () => {
    try {
      const res = await fetch('/api/expenses');
      const data = await res.json();
      if (res.ok) setExpenses(data);
    } catch (err) {
      console.error(err);
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="space-y-6 animate-in fade-in duration-500">
      <div className="flex justify-between items-center">
        <div>
          <h1 className="text-2xl font-bold tracking-tight text-foreground">My Project Expenses</h1>
          <p className="text-muted-foreground mt-1">Review all your personal project-related expenses.</p>
        </div>
        <Link href="/user/expenses/add">
          <Button className="font-bold shadow-md">
            <Plus className="mr-2 h-4 w-4" /> Add Expense
          </Button>
        </Link>
      </div>

      <Card className="shadow-lg border-border/50">
        {loading ? (
          <div className="py-20 text-center text-muted-foreground">Loading...</div>
        ) : expenses.length > 0 ? (
          <div className="overflow-x-auto">
            <table className="w-full text-left text-sm">
              <thead>
                <tr className="border-b border-border text-muted-foreground uppercase text-[10px] tracking-wider font-bold">
                  <th className="px-6 py-4">Date</th>
                  <th className="px-6 py-4">Detail</th>
                  <th className="px-6 py-4">Project</th>
                  <th className="px-6 py-4 text-right">Amount</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-border">
                {expenses.map((ex: any) => (
                  <tr key={ex.expenseid} className="hover:bg-secondary/10 transition-colors">
                    <td className="px-6 py-4 text-muted-foreground">
                      {new Date(ex.expensedate).toLocaleDateString('en-GB')}
                    </td>
                    <td className="px-6 py-4 font-semibold">
                      {ex.expensedetail || 'Expense'}
                    </td>
                    <td className="px-6 py-4 text-[10px] font-bold uppercase text-primary">
                      {ex.projects?.projectname || 'General'}
                    </td>
                    <td className="px-6 py-4 text-right font-bold text-destructive">
                      -${Number(ex.amount).toFixed(2)}
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        ) : (
          <div className="py-20 text-center text-muted-foreground border-2 border-dashed rounded-xl bg-secondary/5">
            No expenses recorded yet.
          </div>
        )}
      </Card>
    </div>
  );
}
