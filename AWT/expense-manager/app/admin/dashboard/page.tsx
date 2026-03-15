import { getUserSession } from '@/lib/auth';
import { redirect } from 'next/navigation';
import Link from 'next/link';
import { prisma } from '@/lib/prisma';
import { Card } from "@/components/ui/Card";
import { TrendingDown, TrendingUp, ArrowUpRight } from 'lucide-react';
export default async function AdminDashboard() {
  const user = await getUserSession();
  if (!user) {
    redirect('/login');
  }
  if (user.role !== 'admin') {
    redirect('/user/dashboard');
  }
  const totalProjects = await prisma.projects.count({
    where: { userid: user.id }
  });
  const expenseSum = await prisma.expenses.aggregate({
    _sum: { amount: true },
    where: { userid: user.id }
  });
  const incomeSum = await prisma.incomes.aggregate({
     _sum: { amount: true },
     where: { userid: user.id }
  });
  const recentProjects = await prisma.projects.findMany({
    where: { userid: user.id },
    orderBy: { created: 'desc' },
    take: 5
  });
  const totalExpenses = expenseSum._sum.amount ? Number(expenseSum._sum.amount).toFixed(2) : '0.00';
  const totalIncome = incomeSum._sum.amount ? Number(incomeSum._sum.amount).toFixed(2) : '0.00';
  const balance = (Number(totalIncome) - Number(totalExpenses)).toFixed(2);
  return (
    <div className="space-y-8 px-2">
      <div className="flex justify-between items-end bg-card backdrop-blur-xl p-8 rounded-[2rem] border border-border shadow-2xl relative overflow-hidden">
         <div className="absolute top-0 right-0 h-40 w-40 bg-primary/10 blur-[80px] rounded-full -mr-20 -mt-20" />
         <div className="relative z-10">
            <h1 className="text-3xl font-bold tracking-tighter text-foreground">Expen<span className="text-primary font-semibold">Track</span></h1>
            <p className="text-primary mt-1 font-medium text-[10px] uppercase tracking-[0.2em] opacity-70">Real-time Project Financial Monitoring</p>
         </div>
         <div className="text-right hidden sm:block relative z-10">
            <p className="text-[9px] font-semibold text-muted-foreground uppercase tracking-[0.3em]">Network Status</p>
            <p className="text-primary font-semibold flex items-center gap-2 justify-end text-[12px]">
               <span className="h-1.5 w-1.5 bg-primary rounded-full animate-pulse shadow-[0_0_10px_hsl(var(--primary))]" /> SYSTEM SECURE
            </p>
         </div>
      </div>
      {}
      <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
        <Card className="border-t-2 border-t-primary overflow-hidden group hover:scale-[1.01]">
           <div className="text-[9px] font-medium text-primary/60 uppercase tracking-[0.2em] mb-1 ml-1">Active Projects</div>
           <div className="mt-1 text-3xl font-medium text-foreground tracking-tight ml-1">{totalProjects}</div>
        </Card>
        <Card className="border-t-2 border-t-rose-500 overflow-hidden group hover:scale-[1.01]">
           <div className="text-[9px] font-medium text-rose-400/60 uppercase tracking-[0.2em] mb-1 ml-1">Total Expenses</div>
           <div className="mt-1 text-3xl font-medium text-rose-500 tracking-tight ml-1">${totalExpenses}</div>
        </Card>
        <Card className="border-t-2 border-t-emerald-400 overflow-hidden group hover:scale-[1.01]">
           <div className="text-[9px] font-medium text-emerald-400/60 uppercase tracking-[0.2em] mb-1 ml-1">Total Balance</div>
           <div className="mt-1 text-3xl font-medium text-emerald-400 tracking-tight ml-1">${balance}</div>
        </Card>
      </div>
      {}
      <div className="grid grid-cols-1 lg:grid-cols-2 gap-8">
        <Card title="Recent Projects" subtitle="List of current projects" className="h-full">
          {recentProjects.length > 0 ? (
             <div className="space-y-3 mt-4">
               {recentProjects.map((p) => (
                 <div key={p.projectid} className="flex items-center justify-between p-4 bg-background hover:bg-card border border-border group cursor-pointer shadow-sm hover:shadow-md">
                    <div className="flex items-center gap-4">
                       <div className="h-10 w-10 rounded-xl bg-background flex items-center justify-center border border-border shadow-2xl group-hover:border-primary/50">
                          <span className="text-primary font-medium text-[11px] tracking-tighter">#{p.projectid}</span>
                       </div>
                       <div>
                         <p className="font-medium text-foreground/90 group-hover:text-primary text-[13px] tracking-tight">{p.projectname}</p>
                         <p className="text-[9px] text-muted-foreground uppercase tracking-widest font-semibold">{p.projectdetail?.substring(0, 30) || 'Project details'}...</p>
                       </div>
                    </div>
                    <div className="text-[9px] font-medium text-primary/80 bg-primary/5 px-2 py-1 rounded-lg border border-primary/10">
                      {new Date(p.created).toLocaleDateString('en-GB')}
                    </div>
                 </div>
               ))}
               <Link href="/admin/projects" className="block text-center text-[9px] text-primary font-medium hover:underline mt-6 uppercase tracking-[0.25em] opacity-60 hover:opacity-100">
                 View All Projects →
               </Link>
             </div>
          ) : (
            <div className="h-48 flex flex-col items-center justify-center text-muted-foreground border-2 border-dashed border-border rounded-[2rem] bg-secondary/5">
               <p className="font-medium uppercase tracking-widest text-[10px]">No projects yet</p>
               <Link href="/admin/projects/add" className="mt-4 px-5 py-2.5 bg-primary text-background rounded-xl text-[9px] font-medium uppercase tracking-widest shadow-xl shadow-primary/20 hover:scale-105">Add Project</Link>
            </div>
          )}
        </Card>
        <Card title="Quick Actions" subtitle="Manage your projects and money" className="h-full">
           <div className="grid grid-cols-1 gap-3 mt-4">
              <Link href="/admin/projects/add" className="flex items-center justify-between p-5 bg-primary/5 rounded-2xl hover:bg-primary/10 border border-primary/10 group">
                <div className="flex items-center gap-4">
                   <div className="h-11 w-11 rounded-xl bg-primary flex items-center justify-center text-background shadow-xl shadow-primary/20">
                      <span className="text-xl font-medium">+</span>
                   </div>
                   <div className="text-left">
                      <h4 className="font-medium text-primary/90 group-hover:underline text-[13px] tracking-tight">Add Project</h4>
                      <p className="text-[9px] text-muted-foreground font-medium uppercase tracking-widest mt-0.5">Define project scope</p>
                   </div>
                </div>
                <ArrowUpRight className="text-primary opacity-20 group-hover:opacity-100 h-4 w-4" />
              </Link>
              <Link href="/admin/expenses/add" className="flex items-center justify-between p-5 bg-rose-500/5 rounded-2xl hover:bg-rose-500/10 border border-rose-500/10 group">
                <div className="flex items-center gap-4">
                   <div className="h-11 w-11 rounded-xl bg-rose-500 flex items-center justify-center text-white shadow-xl shadow-rose-500/20">
                      <TrendingDown className="h-5 w-5" />
                   </div>
                   <div className="text-left">
                      <h4 className="font-medium text-rose-400/90 group-hover:underline text-[13px] tracking-tight">Add Expense</h4>
                      <p className="text-[9px] text-muted-foreground font-medium uppercase tracking-widest mt-0.5">Record project costs</p>
                   </div>
                </div>
                <ArrowUpRight className="text-rose-400 opacity-20 group-hover:opacity-100 h-4 w-4" />
              </Link>
              <Link href="/admin/incomes/add" className="flex items-center justify-between p-5 bg-emerald-500/5 rounded-2xl hover:bg-emerald-500/10 border border-emerald-500/10 group">
                <div className="flex items-center gap-4">
                   <div className="h-11 w-11 rounded-xl bg-emerald-500 flex items-center justify-center text-white shadow-xl shadow-emerald-500/20">
                      <TrendingUp className="h-5 w-5" />
                   </div>
                   <div className="text-left">
                      <h4 className="font-medium text-emerald-400/90 group-hover:underline text-[13px] tracking-tight">Add Income</h4>
                      <p className="text-[9px] text-muted-foreground font-medium uppercase tracking-widest mt-0.5">Record new project income</p>
                   </div>
                </div>
                <ArrowUpRight className="text-emerald-400 opacity-20 group-hover:opacity-100 h-4 w-4" />
              </Link>
           </div>
        </Card>
      </div>
    </div>
  );
}