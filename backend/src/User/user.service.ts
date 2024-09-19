import { HttpException, HttpStatus, Injectable } from "@nestjs/common";
import { InjectRepository } from "@nestjs/typeorm";
import { TypeOrmCrudService } from "@nestjsx/crud-typeorm";
import { User } from "src/entities/user.entity";
import { Readable } from "stream";
import PostgresInterval, { IPostgresInterval } from "postgres-interval";

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

  async saveUser(user: User){
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
      if(user.deleted == false){
        let personalInfo = this.personalInfoCSV(user);
        zip.folder(user.username).file("personalInfo.csv", personalInfo);
      }
    }
    let data = await zip.generateAsync({ type: "uint8array" });
    return data;
  }

  private personalInfoCSV(user : User) : string{
    let sex = ["MALE", "FEMALE", "NOT_SPECIFIED"][user.sex];
    return [
      ["id", "username", "birthdate", "sex"],
      [user.id, user.username, user.birthdate, sex]
    ].join("\n");


  }

  private convertToCSV(arr) {
    const array = [Object.keys(arr[0]) as any[]].concat(arr);
    return array
      .map<any>((row, index) => {
        if(index == 0){
          return row.map(x => x.toString());
        }
        let v = []
        array[0].forEach(x => {
          let b = row[x];
          
          if(b !== null && typeof b === "object" && b.constructor.name === "PostgresInterval"){
            b = (b as IPostgresInterval).toPostgres();
          }
          v.push(b);
        });
        return v.toString();
        // return Object.values(row)
        //   .map((value) => {
        //     if((typeof value) === "string"){
        //       return value;
        //     }

        //     // if((typeof value) === "interval"){
        //     //   return value;
        //     // }
            
        //     return JSON.stringify(value);
        //   })
        //   .toString();
      })
      .join("\n");
  }
}
