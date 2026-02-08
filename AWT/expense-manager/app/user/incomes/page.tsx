'use client';

import { useState, useEffect } from 'react';
import { Card } from '@/components/ui/Card';
import { Button } from '@/components/ui/Button';
import Link from 'next/link';
import { Plus } from 'lucide-react';

export default function UserIncomesListPage() {
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
          <h1 className="text-2xl font-bold tracking-tight text-emerald-600">My Revenue</h1>
          <p className="text-muted-foreground mt-1">Track payments and funding assigned to you.</p>
        </div>
        <Link href="/user/incomes/add">
          <Button className="font-bold shadow-md bg-emerald-600 hover:bg-emerald-700">
            <Plus className="mr-2 h-4 w-4" /> Add Income
          </Button>
        </Link>
      </div>

      <Card className="shadow-lg border-emerald-500/20">
        {loading ? (
          <div className="py-20 text-center text-muted-foreground">Loading...</div>
        ) : incomes.length > 0 ? (
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
                {incomes.map((inc: any) => (
                  <tr key={inc.incomeid} className="hover:bg-emerald-500/5 transition-colors">
                    <td className="px-6 py-4 text-muted-foreground">
                      {new Date(inc.incomedate).toLocaleDateString('en-GB')}
                    </td>
                    <td className="px-6 py-4 font-semibold">
                      {inc.incomedetail || 'Income'}
                    </td>
                    <td className="px-6 py-4 text-[10px] font-bold uppercase text-emerald-600">
                      {inc.projects?.projectname || 'General'}
                    </td>
                    <td className="px-6 py-4 text-right font-bold text-emerald-600">
                      +${Number(inc.amount).toFixed(2)}
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        ) : (
          <div className="py-20 text-center text-muted-foreground border-2 border-dashed rounded-xl bg-secondary/5">
            No income recorded yet.
          </div>
        )}
      </Card>
    </div>
  );
}
