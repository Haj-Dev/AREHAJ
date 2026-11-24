import { useState, type SubmitEvent } from "react";

// Empty = same origin (nginx proxies /api). Override with VITE_API_URL if needed.
const API_URL: string = import.meta.env.VITE_API_URL ?? "";

type Hello = { message: string };

export default function App() {
  const [name, setName] = useState("");
  const [message, setMessage] = useState<string | null>(null);
  const [error, setError] = useState<string | null>(null);
  const [loading, setLoading] = useState(false);

  async function send(e: SubmitEvent<HTMLFormElement>) {
    e.preventDefault();
    setLoading(true);
    setError(null);
    try {
      const res = await fetch(
        `${API_URL}/api/hello?${new URLSearchParams({ name })}`,
        { signal: AbortSignal.timeout(5000) },
      );
      if (!res.ok) throw new Error(`HTTP ${res.status}`);
      const data: Hello = await res.json();
      setMessage(data.message);
    } catch (err) {
      setMessage(null);
      setError(err instanceof Error ? err.message : String(err));
    } finally {
      setLoading(false);
    }
  }

  return (
    <>
      <header className="appbar">Rust + React</header>
      <main>
        <form className="card" onSubmit={send}>
          <h1>Talk to the backend</h1>
          <label>
            Your name
            <input value={name} onChange={(e) => setName(e.target.value)} />
          </label>
          <button type="submit" disabled={loading}>
            {loading ? <span className="spinner" /> : "Say hello"}
          </button>
          {message && <p className="result">{message}</p>}
          {error && <p className="result error">Error: {error}</p>}
        </form>
      </main>
    </>
  );
}
