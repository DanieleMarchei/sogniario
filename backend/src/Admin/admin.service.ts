import { HttpException, HttpStatus, Injectable } from "@nestjs/common";
import { InjectRepository } from "@nestjs/typeorm";
import { TypeOrmCrudService } from "@nestjsx/crud-typeorm";
import { Admin } from "src/entities/admin.entity";

@Injectable()
export class AdminService extends TypeOrmCrudService<Admin> {
  constructor(@InjectRepository(Admin) repo) {
    super(repo);
  }

  async createHashedAdmin(admin: Admin) {
    const bcrypt = require("bcrypt");
    const existingAdmin = await this.repo.findOne({
      where: { username: admin.username },
    });
    if (existingAdmin) {
      throw new HttpException("Mail already used", HttpStatus.CONFLICT);
    }
    admin.password = await bcrypt.hash(admin.password, 10);
    return this.repo.save(admin);
  }

  async saveAdmin(admin:Admin){
    return this.repo.save(admin);
  }
}
