import supabase from '../config/supabase';
import { ApiError } from '../utils/apiError';
import { QueryOptions } from '../types';

type InsertResult<T> = Partial<T>;

type UpdatePayload<T> = Partial<T>;

const DEFAULT_PAGE_SIZE = 100;

export class BaseService<T extends object> {
  constructor(private readonly table: string, private readonly primaryKey: keyof T & string) {}

  async list(options?: QueryOptions<T>): Promise<T[]> {
    let query = supabase.from(this.table).select('*');

    if (options?.filters) {
      query = query.match(options.filters as Record<string, string>);
    }

    if (options?.orderBy) {
      query = query.order(options.orderBy, {
        ascending: options.orderDirection !== 'desc',
      });
    }

    query = this.applyPagination(query, options);

    const { data, error } = await query;

    if (error) {
      throw new ApiError(500, `Failed to fetch ${this.table}.`, error.message);
    }

    return data as T[];
  }

  async getById(id: string | number): Promise<T> {
    const { data, error } = await supabase
      .from(this.table)
      .select('*')
      .eq(this.primaryKey, id as any)
      .maybeSingle();

    if (error) {
      throw new ApiError(500, `Failed to fetch ${this.table} record.`, error.message);
    }

    if (!data) {
      throw new ApiError(404, `${this.table} record not found.`);
    }

    return data as T;
  }

  async create(payload: InsertResult<T>): Promise<T> {
    console.log(`📝 Creating ${this.table} record:`, JSON.stringify(payload, null, 2));
    
    const { data, error } = await supabase
      .from(this.table)
      .insert(payload)
      .select('*')
      .maybeSingle();

    if (error) {
      console.error(`❌ Failed to create ${this.table}:`, error);
      throw new ApiError(500, `Failed to create ${this.table} record.`, error.message);
    }

    if (!data) {
      throw new ApiError(500, `Supabase did not return the created ${this.table} record.`);
    }

    console.log(`✅ Created ${this.table} record with id:`, (data as any)[this.primaryKey]);
    return data as T;
  }

  async update(id: string | number, payload: UpdatePayload<T>): Promise<T> {
    const { data, error } = await supabase
      .from(this.table)
      .update(payload)
      .eq(this.primaryKey, id as any)
      .select('*')
      .maybeSingle();

    if (error) {
      throw new ApiError(500, `Failed to update ${this.table} record.`, error.message);
    }

    if (!data) {
      throw new ApiError(404, `${this.table} record not found.`);
    }

    return data as T;
  }

  async remove(id: string | number): Promise<void> {
    const { error, data } = await supabase
      .from(this.table)
      .delete()
      .eq(this.primaryKey, id as any)
      .select(this.primaryKey)
      .maybeSingle();

    if (error) {
      throw new ApiError(500, `Failed to delete ${this.table} record.`, error.message);
    }

    if (!data) {
      throw new ApiError(404, `${this.table} record not found.`);
    }
  }

  private applyPagination(
    query: any,
    options?: QueryOptions<T>
  ) {
    const limit = options?.limit ?? undefined;
    const offset = options?.offset ?? undefined;

    if (typeof limit === 'number' && typeof offset === 'number') {
      return query.range(offset, offset + limit - 1);
    }

    if (typeof limit === 'number') {
      return query.limit(limit);
    }

    if (typeof offset === 'number') {
      return query.range(offset, offset + DEFAULT_PAGE_SIZE - 1);
    }

    return query;
  }
}
