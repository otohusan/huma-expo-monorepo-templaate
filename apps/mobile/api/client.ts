import { createApiClient } from "api-client";

export const baseUrl = process.env.EXPO_PUBLIC_API_BASE_URL ?? "http://localhost:8888";
export const client = createApiClient(baseUrl);

// NOTE: if you need auth, you can create separate clients and add auth logic in middleware
// export const publicClient = createApiClient(baseUrl);
// export const authClient = createApiClient(baseUrl);

// authClient.use({
//   async onRequest({ request }) {
//     const token = await getAccessToken(); // SecureStoreなど
//     if (token) request.headers.set("Authorization", `Bearer ${token}`);
//     return request;
//   },
// });