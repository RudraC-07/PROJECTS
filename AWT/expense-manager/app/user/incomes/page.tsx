'use client';
import { useState, useEffect } from 'react';
import { Card } from '@/components/ui/Card';
import { Button } from '@/components/ui/Button';
import { ConfirmModal } from '@/components/ui/ConfirmModal';
import Link from 'next/link';
import { Plus, Trash2, Clock, TrendingUp } from 'lucide-react';
export default function UserIncomesListPage() {
  const [incomes, setIncomes] = useState([]);
  const [loading, setLoading] = useState(true);
  const [deleteModal, setDeleteModal] = useState({ isOpen: false, id: 0 });
  useEffect(() => {
    fetchIncomes();
  }, []);
  const fetchIncomes = async () => {
    try {
      setLoading(true);
      const res = await fetch('/api/incomes');
      const data = await res.json();
      if (res.ok) setIncomes(data);
    } catch (err) {
      console.error(err);
    } finally {
      setLoading(false);
    }
  };
  const handleDelete = async () => {
    const { id } = deleteModal;
    try {
      const res = await fetch(`/api/incomes?id=${id}`, {
        method: 'DELETE',
      });
      if (res.ok) {
        setIncomes(incomes.filter((inc: any) => inc.incomeid !== id));
      } else {
        const data = await res.json();
        alert(data.message || 'Failed to delete income');
      }
    } catch (err) {
      console.error(err);
      alert('An error occurred while deleting');
    }
  };
  return (
    <div className="space-y-6">
      <div className="flex justify-between items-center">
        <div>
          <h1 className="text-2xl font-semibold tracking-tight text-emerald-600">My Revenue</h1>
          <p className="text-muted-foreground mt-1">Track payments and funding assigned to you.</p>
        </div>
        <Link href="/user/incomes/add">
          <Button className="font-medium shadow-md bg-emerald-600 hover:bg-emerald-700 rounded-xl px-6">
            <Plus className="mr-2 h-4 w-4" /> Add Income
          </Button>
        </Link>
      </div>
      <Card className="shadow-lg border-emerald-500/20 overflow-hidden">
        {loading ? (
          <div className="py-20 text-center text-muted-foreground">
             <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-emerald-500 mx-auto mb-4"></div>
             Loading revenue records...
          </div>
        ) : incomes.length > 0 ? (
          <div className="overflow-x-auto -mx-5">
            <table className="w-full text-left text-sm border-collapse">
              <thead>
                <tr className="border-y border-border text-muted-foreground uppercase text-[10px] tracking-wider font-semibold bg-emerald-500/5">
                  <th className="px-6 py-4">Date</th>
                  <th className="px-6 py-4">Detail</th>
                  <th className="px-6 py-4">Project</th>
                  <th className="px-6 py-4 text-right">Amount</th>
                  <th className="px-6 py-4 text-center w-24">Actions</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-border">
                {incomes.map((inc: any) => (
                  <tr key={inc.incomeid} className="hover:bg-emerald-500/[0.02] group">
                    <td className="px-6 py-4 text-muted-foreground font-medium">
                      <div className="flex items-center gap-2">
                         <Clock className="h-3 w-3" />
                         {new Date(inc.incomedate).toLocaleDateString('en-GB')}
                      </div>
                    </td>
                    <td className="px-6 py-4 font-semibold text-foreground/90">
                      {inc.incomedetail || 'Income'}
                    </td>
                    <td className="px-6 py-4 text-[10px] font-semibold uppercase text-emerald-600">
                      {inc.projects?.projectname || 'General'}
                    </td>
                    <td className="px-6 py-4 text-right font-medium text-emerald-600 text-sm">
                      +${Number(inc.amount).toFixed(2)}
                    </td>
                    <td className="px-6 py-4">
                      <div className="flex justify-center">
                        <button 
                          onClick={() => setDeleteModal({ isOpen: true, id: inc.incomeid })}
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
            <div className="h-12 w-12 rounded-full bg-emerald-500/10 flex items-center justify-center mx-auto mb-4">
              <TrendingUp className="h-6 w-6 text-emerald-600" />
            </div>
            <p className="text-[10px] font-semibold uppercase tracking-[0.2em]">No revenue recorded yet</p>
            <Link href="/user/incomes/add" className="mt-4 inline-block text-emerald-600 font-semibold hover:underline uppercase text-[10px] tracking-widest opacity-70 hover:opacity-100 transition-opacity">
               Add first payment
            </Link>
          </div>
        )}
      </Card>
      <ConfirmModal 
        isOpen={deleteModal.isOpen}
        onClose={() => setDeleteModal({ ...deleteModal, isOpen: false })}
        onConfirm={handleDelete}
        title="Delete Income"
        message="Are you sure you want to delete this income record? This will permanently remove it from your history."
      />
    </div>
  );
}