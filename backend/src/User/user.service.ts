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
    const existingUser = await this.repo.findOne({
      where: { username: user.username },
    });
    if (existingUser) {
      throw new HttpException("Mail already used", HttpStatus.CONFLICT);
    }
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
      let dreamsCSV = this.convertToCSV(user.dreams);
      let chronotypesCSV = this.convertToCSV(user.chronotypes);
      let psqisCSV = this.convertToCSV(user.psqis);
      zip.folder(user.username).file("dreams.csv", dreamsCSV);
      zip.folder(user.username).file("chronotypes.csv", chronotypesCSV);
      zip.folder(user.username).file("psqis.csv", psqisCSV);
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
