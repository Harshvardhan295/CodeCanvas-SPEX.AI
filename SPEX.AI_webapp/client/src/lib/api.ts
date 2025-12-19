// client/src/lib/api.ts

export const API_BASE_URL = "https://webcrawler-h6ag.onrender.com";

export interface CrawlResponse {
  message: string;
  collection_name: string;
  pages_indexed: number;
  crawled_urls: string[];
}

export interface ChatResponse {
  answer: string;
  sources: string[];
}

export const api = {
  crawl: async (url: string): Promise<CrawlResponse> => {
    const res = await fetch(`${API_BASE_URL}/crawl`, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ 
        url, 
        max_depth: 2, 
        max_pages: 5 
      }),
    });
    if (!res.ok) throw new Error("Failed to connect to backend");
    return res.json();
  },

  chat: async (collection_name: string, question: string, history: any[]): Promise<ChatResponse> => {
    const res = await fetch(`${API_BASE_URL}/chat`, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ 
        collection_name, 
        question, 
        history 
      }),
    });
    if (!res.ok) throw new Error("Failed to get response");
    return res.json();
  }
};