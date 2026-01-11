import type { NextConfig } from "next";

// Force restart to clear cache

const nextConfig: NextConfig = {
  async rewrites() {
    return [
      {
        source: "/api/:path*",
        destination: "https://cardiocheck-q0xa.onrender.com/:path*",
      },
    ];
  },
};

export default nextConfig;
