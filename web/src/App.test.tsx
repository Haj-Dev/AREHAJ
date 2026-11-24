import { cleanup, fireEvent, render, screen } from "@testing-library/react";
import { afterEach, describe, expect, it, vi } from "vitest";
import App from "./App";

describe("App", () => {
  afterEach(() => {
    cleanup();
    vi.unstubAllGlobals();
  });

  it("shows the message returned by the backend", async () => {
    vi.stubGlobal(
      "fetch",
      vi.fn().mockResolvedValue({
        ok: true,
        json: () => Promise.resolve({ message: "Hello, Ada!" }),
      }),
    );

    render(<App />);
    fireEvent.change(screen.getByLabelText("Your name"), {
      target: { value: "Ada" },
    });
    fireEvent.click(screen.getByRole("button", { name: /say hello/i }));

    expect(await screen.findByText("Hello, Ada!")).toBeInTheDocument();
  });

  it("shows an error when the request fails", async () => {
    vi.stubGlobal(
      "fetch",
      vi.fn().mockResolvedValue({ ok: false, status: 500 }),
    );

    render(<App />);
    fireEvent.click(screen.getByRole("button", { name: /say hello/i }));

    expect(await screen.findByText(/error: http 500/i)).toBeInTheDocument();
  });
});
