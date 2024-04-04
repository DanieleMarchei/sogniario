import { HttpException, HttpStatus, Injectable } from "@nestjs/common";
import { InjectRepository } from "@nestjs/typeorm";
import { TypeOrmCrudService } from "@nestjsx/crud-typeorm";
import { Researcher } from "src/entities/researcher.entity";

@Injectable()
export class ResearcherService extends TypeOrmCrudService<Researcher> {
  constructor(@InjectRepository(Researcher) repo) {
    super(repo);
  }

  async createHashedResearcher(researcher: Researcher) {
    const bcrypt = require("bcrypt");
    const existingResearcher = await this.repo.findOne({
      where: { username: researcher.username },
    });
    if (existingResearcher) {
      throw new HttpException("Mail already used", HttpStatus.CONFLICT);
    }
    researcher.password = await bcrypt.hash(researcher.password, 10);
    return this.repo.save(researcher);
  }
}
