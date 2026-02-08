import { cookies } from 'next/headers';
import { redirect } from 'next/navigation';
import Link from 'next/link';
import { TrendingDown, Briefcase, TrendingUp } from 'lucide-react';
import { prisma } from '@/lib/prisma';
import { Card } from "@/components/ui/Card";
import { Button } from "@/components/ui/Button";

export default async function UserDashboard() {
  const cookieStore = await cookies();
  const token = cookieStore.get('auth_token');

  if (!token) {
    redirect('/login');
  }

  const user = JSON.parse(token.value);

  // If role is admin, they might want to see this too, but technically it's for 'people'.
  // We'll allow admin to see a "User View" or just redirect.
  // For now, assume strict roles.
  if (user.role === 'admin') {
     // Admin viewing user dashboard? Maybe for themselves?
     // We will treat admin as a user here too (since they have a userid)
  }

  // Data Fetching
  // If role is 'admin', user.id is userid.
  // If role is 'user', user.id is peopleid.

  let whereCondition: any = {};
  
  if (user.role === 'user') {
    whereCondition = { peopleid: user.id };
  } else {
    // Admin personal expenses? Or all?
    // Let's assume Admin sees their OWN expenses marked with their userid but null peopleid?
    // Or just all expenses for the account?
    // Let's show All Expenses for Admin in this view to be safe.
    whereCondition = { userid: user.id };
  }

  const expenseSum = await prisma.expenses.aggregate({
    _sum: { amount: true },
    where: whereCondition
  });

  const incomeSum = await prisma.incomes.aggregate({
    _sum: { amount: true },
    where: whereCondition
  });

  const recentExpenses = await prisma.expenses.findMany({
    where: whereCondition,
    orderBy: { expensedate: 'desc' },
    take: 5,
    include: { categories: true }
  });

  const recentIncomes = await prisma.incomes.findMany({
    where: whereCondition,
    orderBy: { incomedate: 'desc' },
    take: 5,
    include: { categories: true }
  });

  // Merge and sort transactions
  const allTransactions = [
    ...recentExpenses.map(ex => ({ ...ex, type: 'expense', date: ex.expensedate })),
    ...recentIncomes.map(inc => ({ ...inc, type: 'income', date: inc.incomedate }))
  ].sort((a, b) => new Date(b.date).getTime() - new Date(a.date).getTime()).slice(0, 5);

  const totalExpense = expenseSum._sum.amount ? Number(expenseSum._sum.amount).toFixed(2) : '0.00';
  const totalIncome = incomeSum._sum.amount ? Number(incomeSum._sum.amount).toFixed(2) : '0.00';
  const balance = (Number(totalIncome) - Number(totalExpense)).toFixed(2);

  return (
    <div className="space-y-8 animate-in fade-in duration-1000 px-2">
      <div className="flex justify-between items-center bg-card backdrop-blur-xl p-8 rounded-[2rem] border border-border shadow-2xl relative overflow-hidden">
        <div className="absolute top-0 right-0 h-40 w-40 bg-primary/10 blur-[80px] rounded-full -mr-20 -mt-20" />
        <div className="relative z-10">
           <h1 className="text-3xl font-bold tracking-tighter text-foreground uppercase">My Dashboard</h1>
           <p className="text-primary mt-1 font-bold text-[10px] uppercase tracking-[0.2em] opacity-70">Personal Project Expenses and Income</p>
        </div>
        <div className="flex gap-2 relative z-10">
          <Link href="/user/incomes/add">
            <Button variant="outline" size="sm" className="border-emerald-500/20 text-emerald-400 hover:bg-emerald-500/5">Add Income</Button>
          </Link>
          <Link href="/user/expenses/add">
            <Button size="sm" className="shadow-lg shadow-primary/20">Add Expense</Button>
          </Link>
        </div>
      </div>
      
      {/* Personal Stats Overview */}
      <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
        <Card className="border-t-2 border-t-rose-500 group hover:scale-[1.01] transition-all">
           <div className="text-[9px] font-bold text-rose-400/60 uppercase tracking-[0.2em] mb-1 ml-1">My Total Expenses</div>
           <div className="mt-1 text-3xl font-bold text-rose-500 tracking-tight ml-1">-${totalExpense}</div>
        </Card>
        <Card className="border-t-2 border-t-emerald-500 group hover:scale-[1.01] transition-all">
           <div className="text-[9px] font-bold text-emerald-400/60 uppercase tracking-[0.2em] mb-1 ml-1">My Income</div>
           <div className="mt-1 text-3xl font-bold text-emerald-500 tracking-tight ml-1">${totalIncome}</div>
        </Card>
        <Card className="border-t-2 border-t-primary group hover:scale-[1.01] transition-all">
           <div className="text-[9px] font-bold text-primary/60 uppercase tracking-[0.2em] mb-1 ml-1">Total Balance</div>
           <div className="mt-1 text-3xl font-bold text-primary tracking-tight ml-1">${balance}</div>
        </Card>
      </div>

      {/* User Specific Content */}
      <div className="grid grid-cols-1 lg:grid-cols-2 gap-8">
        <Card title="Recent Activity" subtitle="Your recent expenses and income" className="h-full">
           {allTransactions.length > 0 ? (
             <div className="space-y-3 mt-4">
               {allTransactions.map((tx: any, idx) => (
                 <div key={idx} className="flex items-center justify-between p-4 bg-white/[0.02] rounded-2xl hover:bg-white/[0.05] transition-all border border-white/5 group">
                    <div className="flex items-center gap-4">
                      <div className={`h-10 w-10 rounded-xl bg-background flex items-center justify-center border border-white/10 shadow-sm transition-all ${tx.type === 'expense' ? 'text-rose-500 group-hover:bg-rose-500' : 'text-emerald-500 group-hover:bg-emerald-500'} group-hover:text-background`}>
                        {tx.type === 'expense' ? <TrendingDown className="h-5 w-5" /> : <TrendingUp className="h-5 w-5" />}
                      </div>
                      <div>
                        <p className="font-bold text-foreground/90 group-hover:text-primary transition-colors text-[13px] tracking-tight">{tx.expensedetail || tx.incomedetail || 'Transaction'}</p>
                        <p className="text-[9px] text-muted-foreground uppercase font-bold tracking-widest">{new Date(tx.date).toLocaleDateString('en-GB')}</p>
                      </div>
                    </div>
                    <div className={`font-bold text-[14px] ${tx.type === 'expense' ? 'text-rose-500' : 'text-emerald-500'}`}>
                      {tx.type === 'expense' ? '-' : '+'}${Number(tx.amount).toFixed(2)}
                    </div>
                 </div>
               ))}
               <Link href="/user/expenses" className="block text-center text-[9px] text-primary font-bold hover:underline mt-6 uppercase tracking-[0.25em] opacity-60">
                 View Full History →
               </Link>
             </div>
          ) : (
            <div className="h-48 flex flex-col items-center justify-center text-muted-foreground border-2 border-dashed border-border rounded-[2rem] bg-secondary/5">
               <p className="font-bold uppercase tracking-widest text-[10px]">No activity yet</p>
               <Link href="/user/expenses/add" className="mt-4 px-5 py-2.5 bg-primary text-background rounded-xl text-[9px] font-bold uppercase tracking-widest shadow-xl shadow-primary/20 hover:scale-105 transition-transform">Add First Expense</Link>
            </div>
          )}
        </Card>
        <Card title="Expense Analysis" subtitle="Where your money goes" className="h-full">
           <div className="h-64 flex flex-col items-center justify-center text-muted-foreground/40 border-2 border-dashed border-border rounded-[2.5rem] bg-secondary/5 mt-4">
            <div className="h-10 w-10 rounded-full bg-secondary flex items-center justify-center mb-2">
               <Briefcase className="h-5 w-5 text-muted-foreground/20" />
            </div>
            <span className="text-[9px] font-bold uppercase tracking-[0.3em]">Analysis coming soon</span>
          </div>
        </Card>
      </div>
    </div>
  );
}