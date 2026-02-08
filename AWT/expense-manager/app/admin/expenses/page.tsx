'use client';

import { useState, useEffect } from 'react';
import { Card } from '@/components/ui/Card';
import { Button } from '@/components/ui/Button';
import Link from 'next/link';
import { Plus, Search, Filter, ArrowUpRight } from 'lucide-react';

export default function ExpensesListPage() {
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
          <h1 className="text-2xl font-bold tracking-tight text-foreground">Project Expenses</h1>
          <p className="text-muted-foreground mt-1">Full history of all project-related expenses.</p>
        </div>
        <Link href="/admin/expenses/add">
          <Button className="font-bold shadow-md">
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
            className="pl-10 h-10 w-full rounded-md border border-input bg-card px-3 py-2 text-sm"
          />
        </div>
        <Button variant="outline" className="flex items-center gap-2">
          <Filter className="h-4 w-4" /> Filter
        </Button>
        <Button variant="outline">Export CSV</Button>
      </div>

      <Card className="shadow-lg border-border/50">
        {loading ? (
          <div className="py-20 text-center text-muted-foreground">Loading expenses...</div>
        ) : expenses.length > 0 ? (
          <div className="overflow-x-auto">
            <table className="w-full text-left text-sm">
              <thead>
                <tr className="border-b border-border text-muted-foreground uppercase text-[10px] tracking-wider font-bold bg-secondary/30">
                  <th className="px-6 py-4">Date</th>
                  <th className="px-6 py-4">Detail & Project</th>
                  <th className="px-6 py-4">Category</th>
                  <th className="px-6 py-4 text-right">Amount</th>
                  <th className="px-6 py-4"></th>
                </tr>
              </thead>
              <tbody className="divide-y divide-border">
                {expenses.map((ex: any) => (
                  <tr key={ex.expenseid} className="hover:bg-secondary/10 transition-colors group">
                    <td className="px-6 py-4 text-muted-foreground">
                      {new Date(ex.expensedate).toLocaleDateString('en-GB')}
                    </td>
                    <td className="px-6 py-4">
                      <p className="font-semibold text-foreground">{ex.expensedetail || 'Unspecified Detail'}</p>
                      <p className="text-[10px] text-primary font-bold uppercase">{ex.projects?.projectname || 'General'}</p>
                    </td>
                    <td className="px-6 py-4">
                      <span className="inline-flex items-center rounded-full px-2 py-1 text-[10px] font-medium bg-secondary text-secondary-foreground border border-border">
                        {ex.categories?.categoryname || 'Miscellaneous'}
                      </span>
                    </td>
                    <td className="px-6 py-4 text-right font-bold text-destructive">
                      -${Number(ex.amount).toLocaleString(undefined, { minimumFractionDigits: 2 })}
                    </td>
                    <td className="px-6 py-4 text-right">
                      <Button variant="ghost" size="icon" className="opacity-0 group-hover:opacity-100 transition-opacity">
                        <ArrowUpRight className="h-4 w-4" />
                      </Button>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        ) : (
          <div className="py-20 text-center text-muted-foreground border-2 border-dashed rounded-xl bg-secondary/5 mt-4">
            No expenses recorded yet.
          </div>
        )}
      </Card>
    </div>
  );
}
