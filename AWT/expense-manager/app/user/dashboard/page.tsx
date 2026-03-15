import { getUserSession } from '@/lib/auth';
import { redirect } from 'next/navigation';
import Link from 'next/link';
import { TrendingDown, Briefcase, TrendingUp } from 'lucide-react';
import { prisma } from '@/lib/prisma';
import { Card } from "@/components/ui/Card";
export default async function UserDashboard() {
  const user = await getUserSession();
  if (!user) {
    redirect('/login');
  }
  let whereCondition: any = {};
  if (user.role === 'user') {
    whereCondition = { peopleid: user.id };
  } else {
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
  const allTransactions = [
    ...recentExpenses.map(ex => ({ ...ex, type: 'expense', date: ex.expensedate })),
    ...recentIncomes.map(inc => ({ ...inc, type: 'income', date: inc.incomedate }))
  ].sort((a, b) => new Date(b.date).getTime() - new Date(a.date).getTime()).slice(0, 5);
  const totalExpense = expenseSum._sum.amount ? Number(expenseSum._sum.amount).toFixed(2) : '0.00';
  const totalIncome = incomeSum._sum.amount ? Number(incomeSum._sum.amount).toFixed(2) : '0.00';
  const balance = (Number(totalIncome) - Number(totalExpense)).toFixed(2);
  return (
    <div className="space-y-8 px-2">
      <div className="flex flex-col md:flex-row md:items-center justify-between gap-4">
         <div>
            <h1 className="text-3xl font-semibold tracking-tighter text-foreground uppercase">My Dashboard</h1>
            <p className="text-primary mt-1 font-medium text-[10px] uppercase tracking-[0.2em] opacity-70">Personal Project Expenses and Income</p>
         </div>
         <div className="flex gap-2">
            <Link href="/user/expenses/add">
               <button className="px-5 py-2 bg-rose-500 text-white rounded-xl text-[11px] font-medium shadow-lg shadow-rose-500/20 active:scale-95 transition-transform uppercase tracking-wider">Add Expense</button>
            </Link>
            <Link href="/user/incomes/add">
               <button className="px-5 py-2 bg-emerald-500 text-white rounded-xl text-[11px] font-medium shadow-lg shadow-emerald-500/20 active:scale-95 transition-transform uppercase tracking-wider">Add Income</button>
            </Link>
         </div>
      </div>
      {}
      <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
        <Card className="border-t-2 border-t-rose-500 group hover:scale-[1.01]">
           <div className="text-[9px] font-medium text-rose-400/60 uppercase tracking-[0.2em] mb-1 ml-1">My Total Expenses</div>
           <div className="mt-1 text-3xl font-medium text-rose-500 tracking-tight ml-1">-${totalExpense}</div>
        </Card>
        <Card className="border-t-2 border-t-emerald-500 group hover:scale-[1.01]">
           <div className="text-[9px] font-medium text-emerald-400/60 uppercase tracking-[0.2em] mb-1 ml-1">My Income</div>
           <div className="mt-1 text-3xl font-medium text-emerald-500 tracking-tight ml-1">${totalIncome}</div>
        </Card>
        <Card className="border-t-2 border-t-primary group hover:scale-[1.01]">
           <div className="text-[9px] font-medium text-primary/60 uppercase tracking-[0.2em] mb-1 ml-1">Total Balance</div>
           <div className="mt-1 text-3xl font-medium text-primary tracking-tight ml-1">${balance}</div>
        </Card>
      </div>
      <div className="grid grid-cols-1 lg:grid-cols-2 gap-8">
        <Card title="Recent Activity" subtitle="Your latest transactions" className="h-full">
          {allTransactions.length > 0 ? (
             <div className="space-y-3 mt-4">
               {allTransactions.map((tx: any, idx) => (
                 <div key={idx} className="flex items-center justify-between p-4 bg-background rounded-2xl hover:bg-card border border-border group shadow-sm hover:shadow-md">
                    <div className="flex items-center gap-4">
                      <div className={`h-10 w-10 rounded-xl bg-background flex items-center justify-center border border-border shadow-sm transition-all ${tx.type === 'expense' ? 'text-rose-500 group-hover:bg-rose-500' : 'text-emerald-500 group-hover:bg-emerald-500'} group-hover:text-background`}>
                        {tx.type === 'expense' ? <TrendingDown className="h-5 w-5" /> : <TrendingUp className="h-5 w-5" />}
                      </div>
                      <div>
                        <p className="font-medium text-foreground/90 group-hover:text-primary text-[13px] tracking-tight">{tx.expensedetail || tx.incomedetail || 'Transaction'}</p>
                        <p className="text-[9px] text-muted-foreground uppercase font-medium tracking-widest">{new Date(tx.date).toLocaleDateString('en-GB')}</p>
                      </div>
                    </div>
                    <div className={`font-medium text-[14px] ${tx.type === 'expense' ? 'text-rose-500' : 'text-emerald-500'}`}>
                      {tx.type === 'expense' ? '-' : '+'}${Number(tx.amount).toFixed(2)}
                    </div>
                 </div>
               ))}
               <Link href="/user/expenses" className="block text-center text-[9px] text-primary font-medium hover:underline mt-6 uppercase tracking-[0.25em] opacity-60">
                 View Transaction History →
               </Link>
             </div>
          ) : (
            <div className="h-48 flex flex-col items-center justify-center text-muted-foreground border-2 border-dashed border-border rounded-[2rem] bg-secondary/5">
               <p className="font-medium uppercase tracking-widest text-[10px]">No activity yet</p>
               <Link href="/user/expenses/add" className="mt-4 px-5 py-2.5 bg-primary text-background rounded-xl text-[9px] font-medium uppercase tracking-widest shadow-xl shadow-primary/20 hover:scale-105">Add First Expense</Link>
            </div>
          )}
        </Card>
        <Card title="Quick Analysis" subtitle="Monthly progress" className="h-full">
          <div className="h-full flex flex-col items-center justify-center py-10 opacity-40 grayscale">
            <div className="p-4 rounded-full bg-secondary/20 mb-4 border border-border">
               <Briefcase className="h-5 w-5 text-muted-foreground/20" />
            </div>
            <span className="text-[9px] font-medium uppercase tracking-[0.3em]">Analysis coming soon</span>
          </div>
        </Card>
      </div>
    </div>
  );
}