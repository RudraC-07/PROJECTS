import { Sidebar } from "@/components/Sidebar";
import { getUserSession } from "@/lib/auth";
export default async function AdminLayout({ children }: any) {
  const user = await getUserSession();
  let userName = user?.name || "Admin";
  return (
    <div className="flex h-screen bg-background text-foreground overflow-hidden">
      {" "}
      {}
      <Sidebar role="admin" />{" "}
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
            <span className="px-3 py-1 bg-primary/10 text-primary rounded-full text-xs font-medium border border-primary/20">
              Admin
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