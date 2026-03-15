"use client";
import Link from "next/link";
import { useTheme } from "next-themes";
import {
  Sun,
  Moon,
  LogOut,
  Briefcase,
  LayoutDashboard,
  TrendingDown,
  TrendingUp,
  Users,
  User,
} from "lucide-react";
import { useEffect, useState } from "react";
import { useRouter } from "next/navigation";
export function Sidebar({ role = "normal" }: any) {
  const router = useRouter();
  const userRole = role;
  const { resolvedTheme, setTheme } = useTheme();
  const [mounted, setMounted] = useState(false);
  useEffect(() => {
    setMounted(true);
  }, []);
  const handleLogout = async () => {
    try {
      const res = await fetch("/api/auth/logout", { method: "POST" });
      if (res.ok) {
        router.push("/login");
        router.refresh();
      }
    } catch (error) {
      console.error("Logout failed:", error);
    }
  };
  const dashboardHref =
    userRole === "admin" ? "/admin/dashboard" : "/user/dashboard";
  const commonLinks = [
    { name: "Dashboard", href: dashboardHref, icon: LayoutDashboard },
    {
      name: "Projects",
      href: userRole === "admin" ? "/admin/projects" : "/user/projects",
      icon: Briefcase,
    },
    {
      name: "Expenses",
      href: userRole === "admin" ? "/admin/expenses" : "/user/expenses",
      icon: TrendingDown,
    },
    {
      name: "Incomes",
      href: userRole === "admin" ? "/admin/incomes" : "/user/incomes",
      icon: TrendingUp,
    },
  ];
  const adminLinks = [
    { name: "Manage Users", href: "/admin/users", icon: Users },
  ];
  const normalLinks: any[] = [
  ];
  const linksToShow =
    userRole === "admin"
      ? [...commonLinks, ...adminLinks]
      : [...commonLinks, ...normalLinks];
  return (
    <aside className="w-68 bg-background border-r border-border min-h-screen hidden md:flex flex-col text-foreground shadow-2xl z-20">
      {}
      <div className="flex-shrink-0 flex items-center px-6 h-16 border-b border-border bg-primary/5">
        <div className="h-8 w-8 rounded-lg bg-primary flex items-center justify-center mr-3 shadow-lg shadow-primary/20">
          <Briefcase className="h-5 w-5 text-background" />
        </div>
        <span className="text-xl font-bold tracking-tighter text-foreground">
          Expen<span className="text-primary font-semibold">Track</span>
        </span>
      </div>
      {}
      <div className="px-6 py-5 bg-gradient-to-b from-primary/5 to-transparent">
        <div className="flex items-center gap-3">
          <div className="h-9 w-9 rounded-full bg-secondary flex items-center justify-center border border-border shadow-inner">
            <User className="h-4.5 w-4.5 text-primary" />
          </div>
          <div className="overflow-hidden">
            <p className="text-[12px] font-medium truncate text-foreground tracking-tight">
              Project Lead
            </p>
            <p className="text-[8.5px] text-primary font-medium uppercase tracking-[0.2em] opacity-70">
              {userRole} ACCESS
            </p>
          </div>
        </div>
      </div>
      {}
      <nav className="flex-1 px-4 space-y-1 overflow-y-auto pt-2">
        <p className="px-4 text-[8.5px] font-medium text-muted-foreground uppercase tracking-[0.25em] mb-2 ml-1">
          Workspace
        </p>
        {linksToShow.map((link: any) => {
          const Icon = link.icon;
          return (
            <Link
              key={link.name}
              href={link.href}
              className="group flex items-center px-4 py-2.5 text-[12px] font-medium rounded-xl text-foreground/70 hover:bg-primary/10 hover:text-primary border border-transparent hover:border-primary/10"
            >
              <Icon className="mr-3 h-4.5 w-4.5 text-muted-foreground group-hover:text-primary" />
              {link.name}
            </Link>
          );
        })}
      </nav>
      {}
      <div className="p-4 border-t border-border bg-primary/5 space-y-2">
        {mounted && (
          <button
            onClick={() =>
              setTheme(resolvedTheme === "dark" ? "light" : "dark")
            }
            className="group flex w-full items-center px-4 py-2.5 text-[11px] font-medium rounded-xl text-foreground/60 hover:bg-primary/10 hover:text-primary border border-transparent hover:border-primary/10"
          >
            {resolvedTheme === "dark" ? (
              <Sun className="mr-3 h-4 w-4 text-primary" />
            ) : (
              <Moon className="mr-3 h-4 w-4 text-primary" />
            )}
            {resolvedTheme === "dark" ? "LIGHT MODE" : "DARK MODE"}
          </button>
        )}
        <button
          onClick={handleLogout}
          className="group flex w-full items-center px-4 py-2.5 text-[11px] font-medium rounded-xl text-foreground/60 hover:bg-rose-500/10 hover:text-rose-400"
        >
          <LogOut className="mr-3 h-4 w-4" />
          LOGOUT
        </button>
      </div>
    </aside>
  );
}