import { Sidebar } from "@/components/Sidebar";
import { getUserSession } from "@/lib/auth";
export default async function UserLayout({ children }: any) {
  const user = await getUserSession();
  let userName = user?.name || "User";
  return (
    <div className="flex h-screen bg-background text-foreground overflow-hidden">
      {" "}
      <Sidebar role="normal" />{" "}
      <div className="flex-1 flex flex-col overflow-hidden">
        {" "}
        <header className="bg-card shadow-sm h-16 flex items-center justify-between px-6 border-b border-border">
          {" "}
          <div className="md:hidden">
            {" "}
            <span className="text-muted-foreground">Menu</span>{" "}
          </div>{" "}
          <div className="flex-1 flex justify-end items-center space-x-4">
            {" "}
            <span className="px-3 py-1 bg-emerald-500/10 text-emerald-600 rounded-full text-xs font-medium border border-emerald-500/20">
              User
            </span>{" "}
            <span className="text-foreground font-medium">{userName}</span>{" "}
          </div>{" "}
        </header>{" "}
        <main className="flex-1 overflow-auto p-6 bg-background">
          {" "}
          {children}{" "}
        </main>{" "}
      </div>{" "}
    </div>
  );
}