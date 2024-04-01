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
    const user = await this.usersService.findOne({
      where: { username: username },
    });
    if (user?.password !== pass) {
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
