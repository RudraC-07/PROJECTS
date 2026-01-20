import { Card } from "@/components/ui/Card";
import { Button } from "@/components/ui/Button";

export default function UserDashboard() {
  return (
    <div className="space-y-6">
      <div className="flex justify-between items-center">
        <h1 className="text-2xl font-bold text-gray-900">My Dashboard</h1>
        <Button size="sm">Add Expense</Button>
      </div>
      
      {/* Personal Stats Overview */}
      <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
        <Card>
           <div className="text-sm font-medium text-gray-500">My Total Expenses</div>
           <div className="mt-2 text-3xl font-bold text-gray-900">$1,250.00</div>
        </Card>
        <Card>
           <div className="text-sm font-medium text-gray-500">My Income</div>
           <div className="mt-2 text-3xl font-bold text-green-600">$5,000.00</div>
        </Card>
        <Card>
           <div className="text-sm font-medium text-gray-500">Balance</div>
           <div className="mt-2 text-3xl font-bold text-blue-600">$3,750.00</div>
        </Card>
      </div>

      {/* User Specific Content */}
      <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
        <Card title="My Recent Transactions">
          <div className="h-64 flex items-center justify-center text-gray-400 border-2 border-dashed border-gray-200 rounded-lg">
            Personal transaction history...
          </div>
        </Card>
        <Card title="Expense Breakdown">
           <div className="h-64 flex items-center justify-center text-gray-400 border-2 border-dashed border-gray-200 rounded-lg">
            Chart: Categories...
          </div>
        </Card>
      </div>
    </div>
  );
}
