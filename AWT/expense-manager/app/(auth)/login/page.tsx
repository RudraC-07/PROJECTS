'use client';

import Link from 'next/link';
import { useState } from 'react';
import { useRouter } from 'next/navigation';
import { Button } from '@/components/ui/Button';
import { Input } from '@/components/ui/Input';
import { Card } from '@/components/ui/Card';

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

    // Simulate network delay
    await new Promise(resolve => setTimeout(resolve, 800));

    if (formData.username === 'admin' && formData.password === 'admin@123') {
      router.push('/admin/dashboard');
      return;
    }

    if (formData.username === 'user' && formData.password === 'user@123') {
      router.push('/user/dashboard');
      return;
    }

    setError('Invalid credentials. Use admin/admin@123 or user/user@123');
    setLoading(false);
  };

  return (
    <>
      <div className="sm:mx-auto sm:w-full sm:max-w-md mb-6 text-center">
        <h2 className="text-3xl font-bold tracking-tight text-foreground">Sign in to your account</h2>
        <p className="mt-2 text-sm text-muted-foreground">
          Or{' '}
          <Link href="/register" className="font-medium text-primary hover:text-primary/80">
             create a new account
          </Link>
        </p>
      </div>

      <Card>
        <form className="space-y-6" onSubmit={handleSubmit}>
          

          <Input 
            label="Username" 
            id="username" 
            name="username" 
            type="text" 
            autoComplete="username" 
            required 
            placeholder="Enter your username"
            value={formData.username}
            onChange={handleChange}
          />

          <Input 
            label="Password" 
            id="password" 
            name="password" 
            type="password" 
            autoComplete="current-password" 
            required 
            value={formData.password}
            onChange={handleChange}
          />

          {error && (
            <div className="text-destructive text-sm bg-destructive/10 p-2 rounded">
              {error}
            </div>
          )}

          <div className="flex items-center justify-between">
            <div className="flex items-center">
              <input
                id="remember-me"
                name="remember-me"
                type="checkbox"
                className="h-4 w-4 rounded border-input text-primary focus:ring-ring"
              />
              <label htmlFor="remember-me" className="ml-2 block text-sm text-foreground">
                Remember me
              </label>
            </div>

            <div className="text-sm">
              <a href="#" className="font-medium text-primary hover:text-primary/80">
                Forgot your password?
              </a>
            </div>
          </div>

          <div>
            <Button type="submit" fullWidth disabled={loading}>
              {loading ? 'Signing in...' : 'Sign in'}
            </Button>
          </div>
        </form>

        <div className="mt-6">
          <div className="relative">
            <div className="absolute inset-0 flex items-center">
              <div className="w-full border-t border-border" />
            </div>
            <div className="relative flex justify-center text-sm">
              <span className="bg-background px-2 text-muted-foreground">Or continue with</span>
            </div>
          </div>

          <div className="mt-6 grid grid-cols-2 gap-3">
            <Button variant="secondary" fullWidth>
               Google
            </Button>
            <Button variant="secondary" fullWidth>
               GitHub
            </Button>
          </div>
        </div>
      </Card>
    </>
  );
}
