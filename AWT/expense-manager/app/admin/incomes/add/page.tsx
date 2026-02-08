import { IncomeForm } from "@/components/IncomeForm";
import { cookies } from "next/headers";
import { redirect } from "next/navigation";

export default async function AdminAddIncomePage() {
  const cookieStore = await cookies();
  const token = cookieStore.get('auth_token');

  if (!token) redirect('/login');
  const auth = JSON.parse(token.value);
  if (auth.role !== 'admin') redirect('/user/dashboard');

  return (
    <div className="animate-in fade-in slide-in-from-bottom-4 duration-500">
      <IncomeForm role="admin" />
    </div>
  );
}
