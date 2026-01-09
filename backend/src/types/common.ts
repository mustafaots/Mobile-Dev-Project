export type UUID = string;
export type Timestamp = string;
export type Json = Record<string, unknown> | unknown[] | string | number | boolean | null;

export type OrderDirection = 'asc' | 'desc';

export interface QueryOptions<T> {
  filters?: Partial<T>;
  limit?: number;
  offset?: number;
  orderBy?: keyof T & string;
  orderDirection?: OrderDirection;
}
