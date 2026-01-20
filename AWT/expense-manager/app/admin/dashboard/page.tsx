import { Card } from "@/components/ui/Card";

export default function AdminDashboard() {
  return (
    <div className="space-y-6">
      <h1 className="text-2xl font-bold text-gray-900">Admin Dashboard</h1>
      
      {/* Stats Overview */}
      <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
        <Card>
           <div className="text-sm font-medium text-gray-500">Total Users</div>
           <div className="mt-2 text-3xl font-bold text-gray-900">1,234</div>
        </Card>
        <Card>
           <div className="text-sm font-medium text-gray-500">Total Expenses (All Users)</div>
           <div className="mt-2 text-3xl font-bold text-gray-900">$45,231.89</div>
        </Card>
        <Card>
           <div className="text-sm font-medium text-gray-500">Pending Approvals</div>
           <div className="mt-2 text-3xl font-bold text-orange-600">23</div>
        </Card>
      </div>

      {/* Admin Specific Content */}
      <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
        <Card title="Recent User Registrations">
          <div className="h-64 flex items-center justify-center text-gray-400 border-2 border-dashed border-gray-200 rounded-lg">
            List of new users...
          </div>
        </Card>
        <Card title="System Alerts">
           <div className="h-64 flex items-center justify-center text-gray-400 border-2 border-dashed border-gray-200 rounded-lg">
            System logs and alerts...
          </div>
        </Card>
      </div>
    </div>
  );
}
