import { ExpenseForm } from "@/components/ExpenseForm";
import { cookies } from "next/headers";
import { redirect } from "next/navigation";

export default async function UserAddExpensePage() {
  const cookieStore = await cookies();
  const token = cookieStore.get('auth_token');

  if (!token) redirect('/login');
  const auth = JSON.parse(token.value);

  return (
    <div className="animate-in fade-in slide-in-from-bottom-4 duration-500">
      <ExpenseForm role="user" />
    </div>
  );
}
