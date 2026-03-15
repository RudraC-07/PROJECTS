'use client';
import { useState, useEffect } from 'react';
import { Card } from '@/components/ui/Card';
import { Button } from '@/components/ui/Button';
import { ConfirmModal } from '@/components/ui/ConfirmModal';
import Link from 'next/link';
import { Plus, User, Trash2 } from 'lucide-react';
export default function UsersPage() {
  const [users, setUsers] = useState([]);
  const [loading, setLoading] = useState(true);
  const [deleteModal, setDeleteModal] = useState({ isOpen: false, id: 0, name: '' });
  useEffect(() => {
    fetchUsers();
  }, []);
  const fetchUsers = async () => {
    try {
      setLoading(true);
      const res = await fetch('/api/people');
      const data = await res.json();
      if (res.ok) setUsers(data);
    } catch (err) {
      console.error(err);
    } finally {
      setLoading(false);
    }
  };
  const handleDelete = async () => {
    const { id } = deleteModal;
    try {
      const res = await fetch(`/api/people?id=${id}`, {
        method: 'DELETE',
      });
      if (res.ok) {
        setUsers(users.filter((u: any) => u.peopleid !== id));
      } else {
        const data = await res.json();
        alert(data.message || 'Failed to delete user');
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
          <h1 className="text-2xl font-semibold tracking-tight">Manage Users</h1>
          <p className="text-muted-foreground mt-1">Add and manage sub-users (Peoples) for your account.</p>
        </div>
        <Link href="/admin/users/add">
          <Button className="font-medium shadow-md">
            <Plus className="mr-2 h-4 w-4" /> Add New User
          </Button>
        </Link>
      </div>
      <Card title="Account Members" className="shadow-lg border-border/50 overflow-hidden">
        {loading ? (
          <div className="py-20 text-center">
            <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-primary mx-auto mb-4"></div>
            <p className="text-muted-foreground font-medium">Loading users...</p>
          </div>
        ) : users.length > 0 ? (
          <div className="overflow-x-auto mt-4 -mx-5">
            <table className="w-full text-left text-sm border-collapse">
              <thead>
                <tr className="border-y border-border text-muted-foreground uppercase text-[10px] tracking-wider font-semibold bg-secondary/10">
                  <th className="px-6 py-4">User</th>
                  <th className="px-6 py-4">Contact Info</th>
                  <th className="px-6 py-4 text-center">Status</th>
                  <th className="px-6 py-4 text-center w-24">Actions</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-border">
                {users.map((user: any) => (
                  <tr key={user.peopleid} className="hover:bg-secondary/5 transition-colors group">
                    <td className="px-6 py-4">
                      <div className="flex items-center gap-3">
                        <div className="h-10 w-10 rounded-full bg-primary/10 flex items-center justify-center text-primary font-medium border border-primary/20">
                          <User className="h-5 w-5" />
                        </div>
                        <div>
                          <p className="font-semibold text-foreground group-hover:text-primary">{user.peoplename}</p>
                          <p className="text-[10px] text-muted-foreground font-mono font-medium uppercase tracking-tighter">{user.peoplecode}</p>
                        </div>
                      </div>
                    </td>
                    <td className="px-6 py-4">
                      <p className="text-foreground font-medium">{user.email}</p>
                      <p className="text-xs text-muted-foreground">{user.mobileno || 'No phone provided'}</p>
                    </td>
                    <td className="px-6 py-4 text-center">
                      <span className="inline-flex items-center rounded-full px-2.5 py-0.5 text-[10px] font-semibold uppercase bg-emerald-500/10 text-emerald-600 border border-emerald-500/20 shadow-sm">
                        Active
                      </span>
                    </td>
                    <td className="px-6 py-4">
                      <div className="flex justify-center">
                        <button 
                          onClick={() => setDeleteModal({ isOpen: true, id: user.peopleid, name: user.peoplename })}
                          className="p-2 text-rose-500 hover:bg-rose-500/10 rounded-xl border border-transparent hover:border-rose-500/20 shadow-sm bg-background"
                          title="Delete User"
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
          <div className="py-20 text-center border-2 border-dashed rounded-xl bg-secondary/5 m-6">
            <div className="h-12 w-12 rounded-full bg-muted flex items-center justify-center mx-auto mb-4">
               <User className="h-6 w-6 text-muted-foreground" />
            </div>
            <h3 className="text-lg font-medium text-foreground">No users found</h3>
            <p className="text-muted-foreground mt-1 max-w-xs mx-auto text-sm font-medium">You haven't added any sub-users to your account yet.</p>
            <Link href="/admin/users/add" className="mt-6 inline-block">
              <Button variant="outline" size="sm" className="rounded-xl px-6">Get Started</Button>
            </Link>
          </div>
        )}
      </Card>
      <ConfirmModal 
        isOpen={deleteModal.isOpen}
        onClose={() => setDeleteModal({ ...deleteModal, isOpen: false })}
        onConfirm={handleDelete}
        title="Delete User"
        message={`Are you sure you want to delete "${deleteModal.name}"? This will also permanently remove all expenses and incomes recorded by this user.`}
      />
    </div>
  );
}