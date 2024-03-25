import { Injectable } from "@nestjs/common";
import { InjectRepository } from "@nestjs/typeorm";
import { TypeOrmCrudService } from "@nestjsx/crud-typeorm";
import { Chronotype } from "src/entities/chronotype.entity";

@Injectable()
export class ChronotypeService extends TypeOrmCrudService<Chronotype> {
  constructor(@InjectRepository(Chronotype) repo) {
    super(repo);
  }
}
