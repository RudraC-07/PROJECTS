'use client';

import { useState, useEffect } from 'react';
import { motion, AnimatePresence } from 'framer-motion';
import { useRouter, useSearchParams } from 'next/navigation';
import { Button } from '@/components/ui/Button';
import { Input } from '@/components/ui/Input';
import { Briefcase, ArrowRight, ArrowLeft } from 'lucide-react';

export default function AuthForm({ initialMode = 'login' }: { initialMode?: 'login' | 'register' }) {
  const router = useRouter();
  const searchParams = useSearchParams();
  const [mode, setMode] = useState<'login' | 'register'>(initialMode);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');
  
  const [loginData, setLoginData] = useState({
    username: '',
    password: '',
  });

  const [registerData, setRegisterData] = useState({
    name: '',
    email: '',
    mobile: '',
    password: '',
    confirmPassword: ''
  });

  useEffect(() => {
    if (searchParams.get('registered') === 'true') {
      setMode('login');
    }
  }, [searchParams]);

  const handleLoginChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const { name, value } = e.target;
    setLoginData(prev => ({ ...prev, [name]: value }));
  };

  const handleRegisterChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const { name, value } = e.target;
    setRegisterData(prev => ({ ...prev, [name]: value }));
  };

  const onLogin = async (e: React.FormEvent) => {
    e.preventDefault();
    setLoading(true);
    setError('');
    try {
      const res = await fetch('/api/auth/login', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          email: loginData.username,
          password: loginData.password,
        }),
      });
      const data = await res.json();
      if (!res.ok) throw new Error(data.message || 'Login failed');
      router.push(data.redirectUrl || '/user/dashboard');
      router.refresh();
    } catch (err: any) {
      setError(err.message);
    } finally {
      setLoading(false);
    }
  };

  const onRegister = async (e: React.FormEvent) => {
    e.preventDefault();
    setLoading(true);
    setError('');
    if (registerData.password !== registerData.confirmPassword) {
      setError("Passwords do not match");
      setLoading(false);
      return;
    }
    try {
      const res = await fetch('/api/auth/register', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          name: registerData.name,
          email: registerData.email,
          mobile: registerData.mobile,
          password: registerData.password,
        }),
      });
      const data = await res.json();
      if (!res.ok) throw new Error(data.message || 'Registration failed');
      setMode('login');
      setError('');
    } catch (err: any) {
      setError(err.message);
    } finally {
      setLoading(false);
    }
  };

  const toggleMode = () => {
    const newMode = mode === 'login' ? 'register' : 'login';
    setMode(newMode);
    setError('');
    window.history.pushState({}, '', `/${newMode}`);
  };

  return (
    <div className="min-h-screen aurora-bg flex items-center justify-center p-4">
      {/* Container - Reduced size to max-w-2xl and height */}
      <div className="relative w-full max-w-2xl bg-card rounded-[1.5rem] shadow-2xl overflow-hidden min-h-[480px] flex border border-border/40">
        
        {/* Forms Side (Desktop split into two halves) */}
        <div className="relative w-full flex">
          
          {/* Left Container (Visible during Register) */}
          <div className="hidden md:flex w-1/2 items-center justify-center p-8">
            <AnimatePresence mode="wait">
              {mode === 'register' && (
                <motion.div
                  key="register-form"
                  initial={{ opacity: 0, scale: 0.95 }}
                  animate={{ opacity: 1, scale: 1 }}
                  exit={{ opacity: 0, scale: 0.95 }}
                  className="w-full"
                >
                  <h2 className="text-xl font-bold mb-1">Create Account</h2>
                  <p className="text-muted-foreground mb-4 text-[10px]">Start managing your expenses</p>
                  
                  <form onSubmit={onRegister} className="space-y-2.5">
                    <Input label="Name" name="name" required placeholder="John Doe" value={registerData.name} onChange={handleRegisterChange} className="h-8 text-xs" />
                    <Input label="Email" name="email" type="email" required placeholder="john@example.com" value={registerData.email} onChange={handleRegisterChange} className="h-8 text-xs" />
                    <div className="grid grid-cols-2 gap-2">
                      <Input label="Password" name="password" type="password" required value={registerData.password} onChange={handleRegisterChange} className="h-8 text-xs" />
                      <Input label="Confirm" name="confirmPassword" type="password" required value={registerData.confirmPassword} onChange={handleRegisterChange} className="h-8 text-xs" />
                    </div>
                    {error && <div className="text-rose-400 text-[9px] font-bold bg-rose-500/10 p-2 rounded-lg border border-rose-500/20">{error}</div>}
                    <Button type="submit" fullWidth disabled={loading} size="sm" className="h-9 mt-1">
                      {loading ? 'Wait...' : 'Sign Up'}
                    </Button>
                  </form>
                </motion.div>
              )}
            </AnimatePresence>
          </div>

          {/* Right Container (Visible during Login) */}
          <div className="w-full md:w-1/2 flex items-center justify-center p-8">
             {/* Mobile View handles both forms here */}
             <div className="w-full md:hidden">
                <AnimatePresence mode="wait">
                  {mode === 'login' ? (
                    <motion.div key="m-login" initial={{ opacity: 0 }} animate={{ opacity: 1 }} exit={{ opacity: 0 }}>
                       {/* Login content duplicated for mobile simplicity or extracted */}
                       <h2 className="text-xl font-bold mb-1 text-center">Login</h2>
                       <form onSubmit={onLogin} className="space-y-3 mt-4">
                         <Input label="Username" name="username" required value={loginData.username} onChange={handleLoginChange} className="h-9" />
                         <Input label="Password" name="password" type="password" required value={loginData.password} onChange={handleLoginChange} className="h-9" />
                         <Button type="submit" fullWidth className="h-10 mt-2">Login</Button>
                       </form>
                    </motion.div>
                  ) : (
                    <motion.div key="m-register" initial={{ opacity: 0 }} animate={{ opacity: 1 }} exit={{ opacity: 0 }}>
                       <h2 className="text-xl font-bold mb-1 text-center">Register</h2>
                       <form onSubmit={onRegister} className="space-y-3 mt-4">
                         <Input label="Name" name="name" required value={registerData.name} onChange={handleRegisterChange} className="h-9" />
                         <Input label="Email" name="email" required value={registerData.email} onChange={handleRegisterChange} className="h-9" />
                         <Input label="Password" name="password" type="password" required value={registerData.password} onChange={handleRegisterChange} className="h-9" />
                         <Button type="submit" fullWidth className="h-10 mt-2">Sign Up</Button>
                       </form>
                    </motion.div>
                  )}
                </AnimatePresence>
                <button onClick={toggleMode} className="w-full mt-6 text-[10px] font-bold text-primary uppercase">
                   {mode === 'login' ? 'Create an account' : 'Already have an account?'}
                </button>
             </div>

             {/* Desktop Login Form */}
             <div className="hidden md:block w-full">
                <AnimatePresence mode="wait">
                  {mode === 'login' && (
                    <motion.div
                      key="login-form"
                      initial={{ opacity: 0, scale: 0.95 }}
                      animate={{ opacity: 1, scale: 1 }}
                      exit={{ opacity: 0, scale: 0.95 }}
                    >
                      <h2 className="text-xl font-bold mb-1">Welcome Back</h2>
                      <p className="text-muted-foreground mb-6 text-[10px]">Sign in to your account</p>
                      <form onSubmit={onLogin} className="space-y-4">
                        <Input label="Username" name="username" required placeholder="Email or username" value={loginData.username} onChange={handleLoginChange} className="h-9 text-xs" />
                        <Input label="Password" name="password" type="password" required placeholder="••••••••" value={loginData.password} onChange={handleLoginChange} className="h-9 text-xs" />
                        {error && <div className="text-rose-400 text-[9px] font-bold bg-rose-500/10 p-2 rounded-lg border border-rose-500/20">{error}</div>}
                        <Button type="submit" fullWidth disabled={loading} size="sm" className="h-10 mt-2">
                          {loading ? 'Wait...' : 'Sign In'}
                        </Button>
                      </form>
                    </motion.div>
                  )}
                </AnimatePresence>
             </div>
          </div>
        </div>

        {/* Sliding Overlay (Desktop Only) */}
        <motion.div 
          className="absolute top-0 w-1/2 h-full z-20 hidden md:block pointer-events-none"
          animate={{ x: mode === 'login' ? '0%' : '100%' }}
          transition={{ type: 'spring', damping: 25, stiffness: 120 }}
          initial={false}
        >
          <div className="relative h-full w-full bg-primary overflow-hidden pointer-events-auto">
            <div className="absolute inset-0 bg-primary" />
            <div className="absolute -top-12 -left-12 w-40 h-40 bg-primary-foreground/10 rounded-full blur-3xl" />
            <div className="absolute -bottom-12 -right-12 w-40 h-40 bg-background/20 rounded-full blur-3xl" />

            <div className="relative h-full w-full flex flex-col items-center justify-center text-primary-foreground p-6 text-center">
              <AnimatePresence mode="wait">
                <motion.div 
                  key={mode}
                  initial={{ opacity: 0, y: 10 }}
                  animate={{ opacity: 1, y: 0 }}
                  exit={{ opacity: 0, y: -10 }}
                  transition={{ duration: 0.3 }}
                  className="flex flex-col items-center"
                >
                  <div className="mb-4 p-3 bg-white/20 backdrop-blur-xl rounded-2xl border border-white/20">
                    <Briefcase className="w-8 h-8" />
                  </div>
                  <h1 className="text-2xl font-black tracking-tighter mb-1">
                    Expen<span className="opacity-70">Track</span>
                  </h1>
                  <p className="text-primary-foreground/60 text-[8px] font-bold uppercase tracking-[0.3em] mb-8">
                    Personal Finance
                  </p>
                  
                  <button 
                    onClick={toggleMode}
                    className="group flex items-center gap-2 px-6 py-2 bg-white text-primary rounded-xl text-[10px] font-bold transition-all hover:scale-105 active:scale-95"
                  >
                    {mode === 'login' ? (
                      <>
                        Get Started
                        <ArrowRight className="w-3 h-3" />
                      </>
                    ) : (
                      <>
                        <ArrowLeft className="w-3 h-3" />
                        Sign In
                      </>
                    )}
                  </button>
                </motion.div>
              </AnimatePresence>
            </div>
          </div>
        </motion.div>

      </div>
    </div>
  );
}
