import { Injectable } from "@nestjs/common";
import { InjectRepository } from "@nestjs/typeorm";
import { TypeOrmCrudService } from "@nestjsx/crud-typeorm";
import { Psqi } from "src/entities/psqi.entity";

@Injectable()
export class PsqiService extends TypeOrmCrudService<Psqi> {
  constructor(@InjectRepository(Psqi) repo) {
    super(repo);
  }
}
