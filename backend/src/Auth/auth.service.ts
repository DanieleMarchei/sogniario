import {
  HttpException,
  HttpStatus,
  Injectable,
  UnauthorizedException,
} from "@nestjs/common";
import { UserService } from "src/User/user.service";
import { JwtService } from "@nestjs/jwt";
import { User } from "src/entities/user.entity";

@Injectable()
export class AuthService {
  constructor(
    private usersService: UserService,
    private jwtService: JwtService
  ) {}

  async signIn(
    username: string,
    pass: string
  ): Promise<{ access_token: string }> {
    const bcrypt = require("bcrypt");
    const user = await this.usersService.findOne({
      where: { username: username, deleted: false },
    });
    if (!(await bcrypt.compare(pass, user.password))) {
      throw new UnauthorizedException();
    }
    const payload = { sub: user.id, username: user.username, type: user.type };
    return {
      access_token: await this.jwtService.signAsync(payload),
    };
  }

  async signUp(user: User) {
    return await this.usersService.createHashedUser(user);
  }
}
