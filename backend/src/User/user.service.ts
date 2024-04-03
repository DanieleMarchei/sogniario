import { HttpException, HttpStatus, Injectable } from "@nestjs/common";
import { InjectRepository } from "@nestjs/typeorm";
import { TypeOrmCrudService } from "@nestjsx/crud-typeorm";
import { User } from "src/entities/user.entity";
import { Readable } from "stream";

@Injectable()
export class UserService extends TypeOrmCrudService<User> {
  constructor(@InjectRepository(User) repo) {
    super(repo);
  }

  async createHashedUser(user: User) {
    const bcrypt = require("bcrypt");
    const existingUser = await this.repo.findOne({
      where: { username: user.username },
    });
    if (existingUser) {
      throw new HttpException("Mail already used", HttpStatus.CONFLICT);
    }
    user.password = await bcrypt.hash(user.password, 10);
    return this.repo.save(user);
  }

  async downloadDreams(organizationId) {
    var JSZip = require("jszip");
    let zip = new JSZip();

    let users = await this.repo.find({
      where: { organization: { id: organizationId } },
      relations: { dreams: true, psqis: true, chronotypes: true },
    });

    for (let user of users) {
      console.log(user)
      if (user.dreams.length>0) {
        let dreamsCSV = this.convertToCSV(user.dreams);
        zip.folder(user.username).file("dreams.csv", dreamsCSV);
      }
      if (user.chronotypes.length>0) {
        let chronotypesCSV = this.convertToCSV(user.chronotypes);
        zip.folder(user.username).file("chronotypes.csv", chronotypesCSV);
      }
      if (user.psqis.length>0) {
        let psqisCSV = this.convertToCSV(user.psqis);
        zip.folder(user.username).file("psqis.csv", psqisCSV);
      }
    }
    let data = await zip.generateAsync({ type: "uint8array" });
    return data;
  }
  private convertToCSV(arr) {
    const array = [Object.keys(arr[0])].concat(arr);
    return array
      .map((row) => {
        return Object.values(row)
          .map((value) => {
            return typeof value === "string" ? JSON.stringify(value) : value;
          })
          .toString();
      })
      .join("\n");
  }
}
