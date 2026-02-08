import { cookies } from 'next/headers';
import { redirect } from 'next/navigation';

export default async function Home() {
  const cookieStore = await cookies();
  const token = cookieStore.get('auth_token');

  if (token) {
    try {
      const user = JSON.parse(token.value);
      if (user.role === 'admin') redirect('/admin/dashboard');
      if (user.role === 'user') redirect('/user/dashboard');
    } catch (e) {
      // Invalid token
    }
  }

  redirect('/login');
}
