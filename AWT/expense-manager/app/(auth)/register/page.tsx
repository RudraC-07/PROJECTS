'use client';

import Link from 'next/link';
import { useState } from 'react';
import { useRouter } from 'next/navigation';
import { Button } from '@/components/ui/Button';
import { Input } from '@/components/ui/Input';
import { Card } from '@/components/ui/Card';
import { Briefcase } from 'lucide-react';

export default function RegisterPage() {
  const router = useRouter();
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');
  
  const [formData, setFormData] = useState({
    name: '',
    email: '',
    mobile: '',
    password: '',
    confirmPassword: ''
  });

  const handleChange = (e: any) => {
    const { name, value } = e.target;
    setFormData(prev => ({ ...prev, [name]: value }));
  };

  const handleSubmit = async (e: any) => {
    e.preventDefault();
    setLoading(true);
    setError('');

    if (formData.password !== formData.confirmPassword) {
      setError("Passwords do not match");
      setLoading(false);
      return;
    }

    try {
      const res = await fetch('/api/auth/register', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          name: formData.name,
          email: formData.email,
          mobile: formData.mobile,
          password: formData.password,
        }),
      });

      const data = await res.json();

      if (!res.ok) {
        throw new Error(data.message || 'Registration failed');
      }

      router.push('/login?registered=true');

    } catch (err: any) {
      setError(err.message);
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="min-h-screen aurora-bg flex flex-col justify-center py-12 sm:px-6 lg:px-8">
      <div className="sm:mx-auto sm:w-full sm:max-w-md mb-6 text-center animate-in fade-in slide-in-from-top-4 duration-1000">
        <div className="inline-flex h-12 w-12 items-center justify-center rounded-xl bg-primary shadow-2xl shadow-primary/40 mb-3 glow-primary">
           <Briefcase className="h-6 w-6 text-background" />
        </div>
        <h2 className="text-3xl font-bold tracking-tighter text-foreground">Expen<span className="text-primary font-extrabold">Track</span></h2>
        <p className="mt-2 text-[10px] text-primary font-bold tracking-[0.2em] uppercase opacity-70">
          Create New Account
        </p>
      </div>

      <div className="sm:mx-auto sm:w-full sm:max-w-md animate-in fade-in slide-in-from-bottom-4 duration-1000 delay-100 px-4">
        <Card className="border border-border/50 shadow-2xl p-8 bg-card backdrop-blur-xl rounded-[1.5rem]">
          <form className="space-y-4" onSubmit={handleSubmit}>
            
            <Input 
              label="Full Name" 
              id="name" 
              name="name" 
              type="text" 
              autoComplete="name" 
              required 
              placeholder="John Doe"
              value={formData.name}
              onChange={handleChange}
              className="border-border h-10 rounded-lg px-4"
            />

            <Input 
              label="Email Address" 
              id="email" 
              name="email" 
              type="email" 
              autoComplete="email" 
              required 
              placeholder="you@company.com"
              value={formData.email}
              onChange={handleChange}
              className="border-border h-10 rounded-lg px-4"
            />

            <Input 
              label="Mobile Number" 
              id="mobile" 
              name="mobile" 
              type="tel" 
              autoComplete="tel" 
              required 
              placeholder="+1 (555) 000-0000"
              value={formData.mobile}
              onChange={handleChange}
              className="border-border h-10 rounded-lg px-4"
            />

            <div className="grid grid-cols-2 gap-4">
              <Input 
                label="Password" 
                id="password" 
                name="password" 
                type="password" 
                autoComplete="new-password" 
                required 
                value={formData.password}
                onChange={handleChange}
                className="border-border h-10 rounded-lg px-4"
              />
              
              <Input 
                label="Confirm" 
                id="confirmPassword" 
                name="confirmPassword" 
                type="password" 
                autoComplete="new-password" 
                required 
                value={formData.confirmPassword}
                onChange={handleChange}
                className="border-border h-10 rounded-lg px-4"
              />
            </div>

            {error && (
              <div className="text-rose-400 text-[10px] font-bold bg-rose-500/10 p-3 rounded-lg border border-rose-500/20 animate-shake">
                {error}
              </div>
            )}

            <Button type="submit" fullWidth disabled={loading} size="md" className="h-11 text-[12px] shadow-xl shadow-primary/20 glow-primary bg-primary text-background hover:bg-primary/90 font-bold mt-2">
              {loading ? 'Creating Account...' : 'Sign Up'}
            </Button>
          </form>

          <div className="mt-8 text-center border-t border-border/50 pt-6">
            <p className="text-[9px] text-muted-foreground font-bold uppercase tracking-[0.25em]">
              Already have an account?{' '}
              <Link href="/login" className="font-extrabold text-primary hover:underline transition-colors ml-1">
                Login
              </Link>
            </p>
          </div>
        </Card>
      </div>
    </div>
  );
}
