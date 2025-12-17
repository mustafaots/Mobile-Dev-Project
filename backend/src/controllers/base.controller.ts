import { Request, Response } from 'express';
import { ZodSchema } from 'zod';
import { BaseService } from '../services/base.service';
import { asyncHandler } from '../middleware';
import { buildQueryOptions } from '../utils/parsers';

interface CrudSchemas<CreateDto, UpdateDto> {
  create?: ZodSchema<CreateDto>;
  update?: ZodSchema<UpdateDto>;
}

export class CrudController<
  T extends object,
  CreateDto = Partial<T>,
  UpdateDto = Partial<T>
> {
  constructor(
    private readonly service: BaseService<T>,
    private readonly parseId: (value: string) => string | number,
    private readonly schemas?: CrudSchemas<CreateDto, UpdateDto>
  ) {}

  list = asyncHandler(async (req: Request, res: Response) => {
    const options = buildQueryOptions<T>(req.query);
    const data = await this.service.list(options);
    res.json({ data });
  });

  getById = asyncHandler(async (req: Request, res: Response) => {
    const id = this.parseId(req.params.id);
    const record = await this.service.getById(id);
    res.json({ data: record });
  });

  create = asyncHandler(async (req: Request, res: Response) => {
    const payload = this.schemas?.create ? this.schemas.create.parse(req.body) : req.body;
    const created = await this.service.create(payload as Partial<T>);
    res.status(201).json({ data: created });
  });

  update = asyncHandler(async (req: Request, res: Response) => {
    const id = this.parseId(req.params.id);
    const payload = this.schemas?.update ? this.schemas.update.parse(req.body) : req.body;
    const updated = await this.service.update(id, payload as Partial<T>);
    res.json({ data: updated });
  });

  remove = asyncHandler(async (req: Request, res: Response) => {
    const id = this.parseId(req.params.id);
    await this.service.remove(id);
    res.status(204).send();
  });
}
