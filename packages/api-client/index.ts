import createClient from "openapi-fetch";
import type { paths } from "./schema";

export const DEFAULT_API_BASE_URL = "http://localhost:8888";

export function createApiClient(baseUrl: string = DEFAULT_API_BASE_URL) {
  return createClient<paths>({ baseUrl });
}
