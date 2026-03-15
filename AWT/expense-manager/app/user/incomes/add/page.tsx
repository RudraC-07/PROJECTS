import { getUserSession } from "@/lib/auth";
import { IncomeForm } from "@/components/IncomeForm";
import { cookies } from "next/headers";
import { redirect } from "next/navigation";
export default async function UserAddIncomePage() {
  const auth = await getUserSession();
  if (!auth) redirect("/login");
  return (
    <div className="">
      {" "}
      <IncomeForm role="user" />{" "}
    </div>
  );
}