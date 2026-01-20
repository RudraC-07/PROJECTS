import { Sidebar } from "@/components/Sidebar";

export default function AdminLayout({
  children,
}: any) {
  return (
    <div className="flex h-screen bg-gray-50 overflow-hidden">
      {/* Pass 'admin' role to Sidebar */}
      <Sidebar role="admin" />
      <div className="flex-1 flex flex-col overflow-hidden">
        <header className="bg-white shadow-sm h-16 flex items-center justify-between px-6 border-b border-gray-200">
           <div className="md:hidden">
              <span className="text-gray-500">Menu</span>
           </div>
           <div className="flex-1 flex justify-end items-center space-x-4">
              <span className="px-3 py-1 bg-blue-100 text-blue-800 rounded-full text-xs font-medium">Admin</span>
              <span className="text-gray-700 font-medium">Safeer (Admin)</span>
           </div>
        </header>
        <main className="flex-1 overflow-auto p-6">
          {children}
        </main>
      </div>
    </div>
  );
}
