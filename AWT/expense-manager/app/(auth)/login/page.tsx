'use client';

import Link from 'next/link';
import { useState } from 'react';
import { useRouter } from 'next/navigation';
import { Button } from '@/components/ui/Button';
import { Input } from '@/components/ui/Input';
import { Card } from '@/components/ui/Card';
import { Briefcase } from 'lucide-react';

export default function LoginPage() {
  const router = useRouter();
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');
  
  const [formData, setFormData] = useState({
    username: '',
    password: '',
  });

  const handleChange = (e: any) => {
    const { name, value } = e.target;
    setFormData(prev => ({ ...prev, [name]: value }));
  };

  const handleSubmit = async (e: any) => {
    e.preventDefault();
    setLoading(true);
    setError('');

    try {
      const res = await fetch('/api/auth/login', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          email: formData.username, // Sending username as email/identifier
          password: formData.password,
          // userType: 'user' // Optional: let the server auto-detect
        }),
      });

      const data = await res.json();

      if (!res.ok) {
        throw new Error(data.message || 'Login failed');
      }

      // Redirect
      router.push(data.redirectUrl || '/user/dashboard');
      router.refresh(); // Refresh to update server components with new cookie

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
          Project Finance
        </p>
      </div>

      <div className="sm:mx-auto sm:w-full sm:max-w-md animate-in fade-in slide-in-from-bottom-4 duration-1000 delay-100 px-4">
        <Card className="border border-border/50 shadow-2xl p-8 bg-card backdrop-blur-xl rounded-[1.5rem]">
          <form className="space-y-5" onSubmit={handleSubmit}>
            
            <Input 
              label="Username or Email" 
              id="username" 
              name="username" 
              type="text" 
              autoComplete="username" 
              required 
              placeholder="Enter your username"
              value={formData.username}
              onChange={handleChange}
              className="border-border h-10 rounded-lg px-4"
            />

            <Input 
              label="Password" 
              id="password" 
              name="password" 
              type="password" 
              autoComplete="current-password" 
              required 
              placeholder="Enter password"
              value={formData.password}
              onChange={handleChange}
              className="border-border h-10 rounded-lg px-4"
            />

            {error && (
              <div className="text-rose-400 text-[10px] font-bold bg-rose-500/10 p-3 rounded-lg border border-rose-500/20 animate-shake">
                {error}
              </div>
            )}

            <div className="flex items-center justify-between px-1">
              <div className="flex items-center">
                <input
                  id="remember-me"
                  name="remember-me"
                  type="checkbox"
                  className="h-3.5 w-3.5 rounded border-border bg-secondary text-primary focus:ring-primary cursor-pointer"
                />
                <label htmlFor="remember-me" className="ml-2 block text-[9px] text-muted-foreground font-bold uppercase tracking-wider cursor-pointer">
                  Remember me
                </label>
              </div>

              <div className="text-[9px]">
                <Link href="#" className="font-bold text-primary hover:text-primary/80 transition-colors uppercase tracking-wider">
                  Reset
                </Link>
              </div>
            </div>

            <Button type="submit" fullWidth disabled={loading} size="md" className="h-11 text-[12px] shadow-xl shadow-primary/20 glow-primary bg-primary text-background hover:bg-primary/90 font-bold">
              {loading ? 'Logging in...' : 'Login'}
            </Button>
          </form>

          <div className="mt-8 text-center">
            <p className="text-[9px] text-muted-foreground font-bold uppercase tracking-[0.25em]">
              New to ExpenTrack?{' '}
              <Link href="/register" className="font-extrabold text-primary hover:underline transition-colors ml-1">
                Register
              </Link>
            </p>
          </div>
        </Card>
      </div>
    </div>
  );
}