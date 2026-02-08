'use client';

import { useState } from 'react';
import { useRouter } from 'next/navigation';
import { Card } from '@/components/ui/Card';
import { Button } from '@/components/ui/Button';
import { Input } from '@/components/ui/Input';
import Link from 'next/link';
import { ArrowLeft } from 'lucide-react';

export default function AddUserPage() {
  const router = useRouter();
  const [formData, setFormData] = useState({
    name: '',
    email: '',
    password: '',
    mobile: '',
    description: ''
  });
  const [formLoading, setFormLoading] = useState(false);
  const [message, setMessage] = useState({ type: '', text: '' });

  const handleChange = (e: any) => {
    setFormData({ ...formData, [e.target.name]: e.target.value });
  };

  const handleSubmit = async (e: any) => {
    e.preventDefault();
    setFormLoading(true);
    setMessage({ type: '', text: '' });

    try {
      const res = await fetch('/api/people', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(formData),
      });

      const data = await res.json();

      if (!res.ok) throw new Error(data.message);

      setMessage({ type: 'success', text: 'User created successfully!' });
      
      // Redirect back after a short delay
      setTimeout(() => {
        router.push('/admin/users');
        router.refresh();
      }, 1500);

    } catch (err: any) {
      setMessage({ type: 'error', text: err.message });
      setFormLoading(false);
    }
  };

  return (
    <div className="max-w-3xl mx-auto space-y-6 animate-in fade-in slide-in-from-bottom-4 duration-500">
      <div className="flex items-center gap-4">
        <Link href="/admin/users">
          <Button variant="ghost" size="icon" className="rounded-full">
            <ArrowLeft className="h-5 w-5" />
          </Button>
        </Link>
        <div>
          <h1 className="text-2xl font-bold">Add New User</h1>
          <p className="text-muted-foreground">Fill in the details to create a new sub-user account.</p>
        </div>
      </div>

      <Card className="border-border/50 shadow-xl p-8">
        <form onSubmit={handleSubmit} className="space-y-6">
          <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
            <Input 
              label="Full Name" 
              name="name" 
              required 
              value={formData.name} 
              onChange={handleChange} 
              placeholder="John Doe" 
              className="bg-secondary/30"
            />
            <Input 
              label="Email Address" 
              name="email" 
              type="email" 
              required 
              value={formData.email} 
              onChange={handleChange} 
              placeholder="john@example.com" 
              className="bg-secondary/30"
            />
            <Input 
              label="Password" 
              name="password" 
              type="password" 
              required 
              value={formData.password} 
              onChange={handleChange} 
              placeholder="••••••••"
              className="bg-secondary/30"
            />
            <Input 
              label="Mobile Number" 
              name="mobile" 
              value={formData.mobile} 
              onChange={handleChange} 
              placeholder="+1 (555) 000-0000" 
              className="bg-secondary/30"
            />
          </div>
          
          <Input 
            label="Description (Optional)" 
            name="description" 
            value={formData.description} 
            onChange={handleChange} 
            placeholder="e.g. Department, Role, or Notes"
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
            <Button type="submit" disabled={formLoading} className="flex-1 font-bold h-11" size="lg">
              {formLoading ? 'Creating User...' : 'Create User Account'}
            </Button>
            <Link href="/admin/users" className="flex-1">
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
