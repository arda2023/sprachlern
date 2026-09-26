import "jsr:@supabase/functions-js@2/edge-runtime.d.ts";

const GEMINI_API_KEY = Deno.env.get("GEMINI");
const GEMINI_URL =
"https://generativelanguage.googleapis.com/v1beta/models/gemini-3.8-flash:generateContent";
Deno.serve(async (req: Request) => {
  if (req.method !== "POST") {
    return new Response(JSON.stringify({ error: "Method not allowed" }), {
      status: 405,
      headers: { "Content-Type": "application/json" },
    });
  }

  if (!GEMINI_API_KEY) {
    return new Response(
      JSON.stringify({ error: "GEMINI secret not configured" }),
      { status: 500, headers: { "Content-Type": "application/json" } },
    );
  }

  try {
    const { germanSentence } = await req.json();

    if (!germanSentence || typeof germanSentence !== "string") {
      return new Response(
        JSON.stringify({ error: "germanSentence (string) is required" }),
        { status: 400, headers: { "Content-Type": "application/json" } },
      );
    }

    const prompt =
      `Übersetze diesen deutschen Satz ins Englische und wähle ein ` +
      `pädagogisch sinnvolles Wort als Lücke aus. Antworte NUR mit JSON, ` +
      `keine Erklärung, kein Markdown:\n` +
      `{"englishSentence": "...", "gapWord": "..."}\n\n` +
      `Deutscher Satz: "${germanSentence}"`;

    const geminiResponse = await fetch(`${GEMINI_URL}?key=${GEMINI_API_KEY}`, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({
        contents: [{ parts: [{ text: prompt }] }],
        generationConfig: { responseMimeType: "application/json" },
      }),
    });

    if (!geminiResponse.ok) {
      const errText = await geminiResponse.text();
      return new Response(
        JSON.stringify({ error: "Gemini request failed", details: errText }),
        { status: 502, headers: { "Content-Type": "application/json" } },
      );
    }

    const geminiData = await geminiResponse.json();
    const rawText = geminiData.candidates?.[0]?.content?.parts?.[0]?.text;

    if (!rawText) {
      return new Response(
        JSON.stringify({ error: "No content returned from Gemini" }),
        { status: 502, headers: { "Content-Type": "application/json" } },
      );
    }

    const parsed = JSON.parse(rawText);

    return new Response(JSON.stringify(parsed), {
      status: 200,
      headers: { "Content-Type": "application/json" },
    });
  } catch (err) {
    return new Response(
      JSON.stringify({ error: "Unexpected error", details: String(err) }),
      { status: 500, headers: { "Content-Type": "application/json" } },
    );
  }
});