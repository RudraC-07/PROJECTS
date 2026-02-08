'use client';

import { useState, useEffect } from 'react';
import { Card } from '@/components/ui/Card';
import { Button } from '@/components/ui/Button';
import Link from 'next/link';
import { Plus, Search, Filter, TrendingUp } from 'lucide-react';

export default function IncomesListPage() {
  const [incomes, setIncomes] = useState([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    fetchIncomes();
  }, []);

  const fetchIncomes = async () => {
    try {
      const res = await fetch('/api/incomes');
      const data = await res.json();
      if (res.ok) setIncomes(data);
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
          <h1 className="text-2xl font-bold tracking-tight text-emerald-600">Project Income</h1>
          <p className="text-muted-foreground mt-1">Detailed log of all project income and payments.</p>
        </div>
        <Link href="/admin/incomes/add">
          <Button className="font-bold shadow-md bg-emerald-600 hover:bg-emerald-700">
            <Plus className="mr-2 h-4 w-4" /> Add Income
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
        <Button variant="outline">Export Data</Button>
      </div>

      <Card className="shadow-lg border-emerald-500/20 border-t-4 border-t-emerald-500">
        {loading ? (
          <div className="py-20 text-center text-muted-foreground">Loading income data...</div>
        ) : incomes.length > 0 ? (
          <div className="overflow-x-auto">
            <table className="w-full text-left text-sm">
              <thead>
                <tr className="border-b border-border text-muted-foreground uppercase text-[10px] tracking-wider font-bold bg-emerald-500/5">
                  <th className="px-6 py-4">Date</th>
                  <th className="px-6 py-4">Detail & Project</th>
                  <th className="px-6 py-4">Category</th>
                  <th className="px-6 py-4 text-right">Amount</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-border">
                {incomes.map((inc: any) => (
                  <tr key={inc.incomeid} className="hover:bg-emerald-500/5 transition-colors group">
                    <td className="px-6 py-4 text-muted-foreground">
                      {new Date(inc.incomedate).toLocaleDateString('en-GB')}
                    </td>
                    <td className="px-6 py-4">
                      <p className="font-semibold text-foreground">{inc.incomedetail || 'Unspecified Detail'}</p>
                      <p className="text-[10px] text-emerald-600 font-bold uppercase">{inc.projects?.projectname || 'General Revenue'}</p>
                    </td>
                    <td className="px-6 py-4">
                      <span className="inline-flex items-center rounded-full px-2 py-1 text-[10px] font-medium bg-emerald-500/10 text-emerald-600 border border-emerald-500/20">
                        {inc.categories?.categoryname || 'Funding'}
                      </span>
                    </td>
                    <td className="px-6 py-4 text-right font-bold text-emerald-600">
                      +${Number(inc.amount).toLocaleString(undefined, { minimumFractionDigits: 2 })}
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        ) : (
          <div className="py-20 text-center text-muted-foreground border-2 border-dashed rounded-xl bg-secondary/5 mt-4">
            <div className="h-12 w-12 rounded-full bg-emerald-500/10 flex items-center justify-center mx-auto mb-4">
              <TrendingUp className="h-6 w-6 text-emerald-600" />
            </div>
            <p>No income recorded yet.</p>
            <Link href="/admin/incomes/add" className="mt-4 inline-block text-emerald-600 font-bold hover:underline">Record your first payment</Link>
          </div>
        )}
      </Card>
    </div>
  );
}
