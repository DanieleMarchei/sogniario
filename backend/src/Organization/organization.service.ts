import { Injectable } from "@nestjs/common";
import { InjectRepository } from "@nestjs/typeorm";
import { TypeOrmCrudService } from "@nestjsx/crud-typeorm";
import { Organization } from "src/entities/organization.entity";

@Injectable()
export class OrganizationService extends TypeOrmCrudService<Organization> {
  constructor(@InjectRepository(Organization) repo) {
    super(repo);
  }
}
