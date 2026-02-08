'use client';

import { useState, useEffect } from 'react';
import { useRouter } from 'next/navigation';
import { Card } from '@/components/ui/Card';
import { Button } from '@/components/ui/Button';
import { Input } from '@/components/ui/Input';
import Link from 'next/link';
import { ArrowLeft, Wallet } from 'lucide-react';

export function ExpenseForm({ role, peoples = [] }: { role: string, peoples?: any[] }) {
  const router = useRouter();
  const [categories, setCategories] = useState([]);
  const [subCategories, setSubCategories] = useState([]);
  const [projects, setProjects] = useState([]);
  const [loading, setLoading] = useState(false);
  const [message, setMessage] = useState({ type: '', text: '' });

  const [formData, setFormData] = useState({
    amount: '',
    categoryId: '',
    subCategoryId: '',
    projectId: '',
    date: new Date().toISOString().split('T')[0],
    detail: '',
    description: '',
    peopleId: role === 'admin' ? '' : 'self'
  });

  useEffect(() => {
    fetchCategories();
    fetchProjects();
  }, []);

  const fetchCategories = async () => {
    try {
      const res = await fetch('/api/categories');
      const data = await res.json();
      if (res.ok) setCategories(data);
    } catch (err) {
      console.error('Failed to fetch categories');
    }
  };

  const fetchProjects = async () => {
    try {
      const res = await fetch('/api/projects');
      const data = await res.json();
      if (res.ok) setProjects(data);
    } catch (err) {
      console.error('Failed to fetch projects');
    }
  };

  const handleChange = (e: any) => {
    const { name, value } = e.target;
    
    // Logic to update subcategories list when category changes
    if (name === 'categoryId') {
      const selectedCat: any = categories.find((c: any) => c.categoryid.toString() === value);
      setSubCategories(selectedCat ? selectedCat.sub_categories : []);
      setFormData({ ...formData, categoryId: value, subCategoryId: '' }); // Reset subcategory
    } else {
      setFormData({ ...formData, [name]: value });
    }
  };

  const handleSubmit = async (e: any) => {
    e.preventDefault();
    setLoading(true);
    setMessage({ type: '', text: '' });

    try {
      const res = await fetch('/api/expenses', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(formData),
      });

      const data = await res.json();

      if (!res.ok) throw new Error(data.message);

      setMessage({ type: 'success', text: 'Expense recorded successfully!' });
      
      setTimeout(() => {
        router.push(role === 'admin' ? '/admin/dashboard' : '/user/dashboard');
        router.refresh();
      }, 1500);

    } catch (err: any) {
      setMessage({ type: 'error', text: err.message });
      setLoading(false);
    }
  };

  return (
    <div className="max-w-3xl mx-auto space-y-6">
      <div className="flex items-center gap-4">
        <Link href={role === 'admin' ? '/admin/dashboard' : '/user/dashboard'}>
          <Button variant="ghost" size="icon" className="rounded-full">
            <ArrowLeft className="h-5 w-5" />
          </Button>
        </Link>
        <div>
          <h1 className="text-2xl font-bold">Add Expense</h1>
          <p className="text-muted-foreground text-sm">Log a new expense for your project.</p>
        </div>
      </div>

      <Card className="shadow-xl border-border/50 p-8">
        <form onSubmit={handleSubmit} className="space-y-6">
          <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
            <div className="space-y-2">
              <label className="text-sm font-medium">Amount ($)</label>
              <div className="relative">
                <span className="absolute left-3 top-2.5 text-muted-foreground">$</span>
                <input 
                  type="number" 
                  step="0.01"
                  name="amount"
                  required
                  value={formData.amount}
                  onChange={handleChange}
                  className="flex h-10 w-full rounded-md border border-input bg-secondary/30 px-8 py-2 text-sm ring-offset-background file:border-0 file:bg-transparent file:text-sm file:font-medium placeholder:text-muted-foreground focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:cursor-not-allowed disabled:opacity-50"
                  placeholder="0.00"
                />
              </div>
            </div>

            <div className="space-y-2">
              <label className="text-sm font-medium">Category</label>
              <select 
                name="categoryId"
                value={formData.categoryId}
                onChange={handleChange}
                className="flex h-10 w-full rounded-md border border-input bg-secondary/30 px-3 py-2 text-sm ring-offset-background file:border-0 file:bg-transparent file:text-sm file:font-medium placeholder:text-muted-foreground focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:cursor-not-allowed disabled:opacity-50"
              >
                <option value="">Select Category</option>
                {categories.map((cat: any) => (
                  <option key={cat.categoryid} value={cat.categoryid}>
                    {cat.categoryname}
                  </option>
                ))}
              </select>
            </div>

            <div className="space-y-2">
              <label className="text-sm font-medium">Project</label>
              <select 
                name="projectId"
                value={formData.projectId}
                onChange={handleChange}
                className="flex h-10 w-full rounded-md border border-input bg-secondary/30 px-3 py-2 text-sm ring-offset-background file:border-0 file:bg-transparent file:text-sm file:font-medium placeholder:text-muted-foreground focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:cursor-not-allowed disabled:opacity-50"
              >
                <option value="">Select Project</option>
                {projects.map((proj: any) => (
                  <option key={proj.projectid} value={proj.projectid}>
                    {proj.projectname}
                  </option>
                ))}
              </select>
            </div>

            <div className="space-y-2">
              <label className="text-sm font-medium">Sub Category</label>
              <select 
                name="subCategoryId"
                value={formData.subCategoryId}
                onChange={handleChange}
                disabled={!formData.categoryId}
                className="flex h-10 w-full rounded-md border border-input bg-secondary/30 px-3 py-2 text-sm ring-offset-background file:border-0 file:bg-transparent file:text-sm file:font-medium placeholder:text-muted-foreground focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:cursor-not-allowed disabled:opacity-50"
              >
                <option value="">{formData.categoryId ? 'Select Sub Category' : 'Select Category First'}</option>
                {subCategories.map((sub: any) => (
                  <option key={sub.subcategoryid} value={sub.subcategoryid}>
                    {sub.subcategoryname}
                  </option>
                ))}
              </select>
            </div>

            <Input 
              label="Date" 
              name="date" 
              type="date" 
              required 
              value={formData.date} 
              onChange={handleChange} 
              className="bg-secondary/30"
            />

            <Input 
              label="Expense Detail" 
              name="detail" 
              value={formData.detail} 
              onChange={handleChange} 
              placeholder="e.g. Grocery shopping"
              className="bg-secondary/30"
            />
          </div>

          {role === 'admin' && peoples.length > 0 && (
            <div className="space-y-2">
              <label className="text-sm font-medium">Allocate to Person</label>
              <select 
                name="peopleId"
                value={formData.peopleId}
                onChange={handleChange}
                className="flex h-10 w-full rounded-md border border-input bg-secondary/30 px-3 py-2 text-sm ring-offset-background file:border-0 file:bg-transparent file:text-sm file:font-medium placeholder:text-muted-foreground focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:cursor-not-allowed disabled:opacity-50"
              >
                <option value="0">Me (Admin)</option>
                {peoples.map((p: any) => (
                  <option key={p.peopleid} value={p.peopleid}>
                    {p.peoplename}
                  </option>
                ))}
              </select>
            </div>
          )}

          <Input 
            label="Additional Description (Optional)" 
            name="description" 
            value={formData.description} 
            onChange={handleChange} 
            placeholder="Notes about this expense..."
            className="bg-secondary/30"
          />

          {message.text && (
            <div className={`p-4 rounded-md text-sm font-medium border ${
              message.type === 'success' 
                ? 'bg-emerald-500/10 text-emerald-600 border-emerald-500/20' 
                : 'bg-destructive/10 text-destructive border-destructive/20'
            }`}>
              {message.text}
            </div>
          )}

          <div className="flex gap-4 pt-4">
            <Button type="submit" disabled={loading} className="flex-1 font-bold h-11" size="lg">
              <Wallet className="mr-2 h-4 w-4" />
              {loading ? 'Recording...' : 'Save Expense'}
            </Button>
            <Link href={role === 'admin' ? '/admin/dashboard' : '/user/dashboard'} className="flex-1">
              <Button type="button" variant="outline" className="w-full h-11" size="lg">
                Cancel
              </Button>
            </Link>
          </div>
        </form>
      </Card>
    </div>
  );
}
