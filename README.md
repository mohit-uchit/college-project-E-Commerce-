# Shoplify — College Project E-Commerce

Small full-stack e-commerce demo used for a college project. Contains a Node/Express backend and a React frontend (Vite).

---

**Repository structure**

- `backend/` — Express API, MongoDB models, routes, and payment integration.
- `frontened/` — React + Vite frontend (note: directory name is `frontened` in this repo).

---

**Getting started (prerequisites)**

- Node.js 16+ and npm
- MongoDB running locally or a connection string
- (Optional) ngrok / public URL for webhook testing

---

**Environment variables**

Backend (`backend/.env`) should include at least:

- `NODE_ENV=development`
- `MONGODB_URI=mongodb://localhost:27017/ecommerce`
- `JWT_SECRET=your_jwt_secret`
- `STRIPE_SECRET_KEY=sk_test_...` (if using Stripe)
- `STRIPE_WEBHOOK_SECRET=whsec_...` (if using Stripe webhooks)
- `CLIENT_URL=http://localhost:3000`
- `PORT=5000`
- `ADMIN_CODE=2003` <-- default admin code used by `/api/auth/register-admin`

Frontend (`frontened/`) — environment variables are optional; frontend requests are proxied to the backend using the `/api` prefix.

---

**Run locally**

1. Install dependencies

```bash
# from repo root
cd backend
npm install

# in a separate terminal
cd ../frontened
npm install
```

2. Start backend

```bash
cd backend
# if you use nodemon
npx nodemon server.js
# or
node server.js
```

3. Start frontend

```bash
cd frontened
npm run dev
```

Open the app at the Vite dev URL (typically `http://localhost:5173` or `http://localhost:3000` depending on your setup).

---

**Admin accounts**

- There is a dedicated admin registration endpoint: `POST /api/auth/register-admin`.
- The endpoint requires an `adminCode` in the body which is validated against `process.env.ADMIN_CODE`.
- The default admin code in this repo is `2003` (see `backend/.env`). You can change it there.

Frontend notes:

- The app already contains admin pages and routes:
  - `/admin` — Admin orders panel
  - `/admin/orders` — explicit orders route (renders Admin page)
  - `/admin/login` — Admin login
  - `/admin/register` — Admin registration (submits `adminCode`)
  - `/admin/profile` — Admin profile
- Admin pages import `frontened/src/pages/admin.css` for shared admin styling.
- The regular register/login pages also include links to the admin auth pages for convenience.

---

**Troubleshooting**

- If `git push` fails with "Could not resolve host: github.com" — double-check your network/DNS/proxy settings (see README notes in the project or run `ping github.com` / `nslookup github.com`).
- If the frontend can't reach the backend, verify the backend port and CORS configuration in `backend/server.js`.

---

**Next improvements (ideas)**

- Add admin product management pages (create/edit/delete products).
- Add tests for critical API endpoints.
- Protect the admin register route further (invite-only flow or only create admins manually).

---

If you'd like, I can:

- Run the dev servers and verify the admin pages, or
- Commit these README changes and create a GitHub release (if your network allows pushes).
