import { ParsedQs } from 'qs';
import { ApiError } from './apiError';
import { OrderDirection, QueryOptions } from '../types';

const uuidRegex =
  /^(?:[0-9a-f]{8}-[0-9a-f]{4}-[1-5][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12})$/i;

export const parseNumericId = (value: string, label = 'id'): number => {
  const parsed = Number(value);
  if (!Number.isFinite(parsed)) {
    throw new ApiError(400, `Invalid ${label}, expected a numeric value.`);
  }
  return parsed;
};

export const parseUUID = (value: string, label = 'id'): string => {
  if (!uuidRegex.test(value)) {
    throw new ApiError(400, `Invalid ${label}, expected a UUID value.`);
  }
  return value;
};

export const parseOrderDirection = (value?: unknown): OrderDirection | undefined => {
  if (!value) {
    return undefined;
  }
  const normalized = Array.isArray(value) ? value[0] : value;
  if (typeof normalized !== 'string') {
    return undefined;
  }
  if (normalized !== 'asc' && normalized !== 'desc') {
    throw new ApiError(400, 'orderDirection must be either asc or desc.');
  }
  return normalized;
};

export const parseNumber = (value?: unknown): number | undefined => {
  if (value === undefined) {
    return undefined;
  }
  const normalized = Array.isArray(value) ? value[0] : value;
  if (typeof normalized !== 'string') {
    return undefined;
  }
  const parsed = Number(normalized);
  if (!Number.isFinite(parsed)) {
    throw new ApiError(400, `Expected a numeric value but received ${normalized}.`);
  }
  return parsed;
};

export const buildQueryOptions = <T>(query: ParsedQs): QueryOptions<T> => {
  const { limit, offset, orderBy, orderDirection, ...rest } = query;

  const filters = Object.entries(rest).reduce<Partial<T>>((acc, [key, value]) => {
    if (typeof value === 'string' && value.length) {
      (acc as Record<string, string>)[key] = value;
    }
    return acc;
  }, {});

  return {
    limit: parseNumber(limit),
    offset: parseNumber(offset),
    orderBy: typeof orderBy === 'string' ? (orderBy as keyof T & string) : undefined,
    orderDirection: parseOrderDirection(orderDirection),
    filters: Object.keys(filters).length ? filters : undefined,
  };
};
