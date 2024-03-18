import { Injectable } from "@nestjs/common";
import { InjectRepository } from "@nestjs/typeorm";
import { TypeOrmCrudService } from "@nestjsx/crud-typeorm";
import { Dream } from "src/entities/dream.entity";

@Injectable()
export class DreamService extends TypeOrmCrudService<Dream> {
  constructor(@InjectRepository(Dream) repo) {
    super(repo);
  }
}
