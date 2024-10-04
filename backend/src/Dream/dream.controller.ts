import { applyDecorators, Controller, UnauthorizedException, UseGuards } from "@nestjs/common";
import { ApiSecurity, ApiTags } from "@nestjs/swagger";
import { CreateManyDto, Crud, CrudAuth, CrudController, CrudRequest, CrudRequestInterceptor, GetManyDefaultResponse, Override, ParsedBody, ParsedRequest } from "@nestjsx/crud";
import { DreamService } from "./dream.service";
import { Dream } from "src/entities/dream.entity";
import { Roles, ProtectCreate, CreateType, ProtectDelete, ProtectAlter } from "src/Auth/roles.decorator";
import { UserType } from "src/entities/user_type.enum";
import { JwtService } from "@nestjs/jwt";
import { AuthUser } from "src/Auth/auth.decorator";
import { UserService } from "src/User/user.service";
import { User } from "src/entities/user.entity";

@Crud({
  model: {
    type: Dream,
  }
})
@ApiTags("Dream")
@ApiSecurity("bearer")
@Controller("dream")
export class DreamController implements CrudController<Dream> {
  constructor(public service: DreamService) {}

  get base(): CrudController<Dream> {
    return this;
  }

  @Override()
  @Roles(UserType.ADMIN, UserType.RESEARCHER, UserType.USER)
  async getMany(@ParsedRequest() req: CrudRequest, @AuthUser() user: any): Promise<GetManyDefaultResponse<Dream> | Dream[]> {

    let data = await this.base.getManyBase(req);
    let userType = user.type;

    if (userType == UserType.ADMIN) return data;
    
    let dataToCheck : Dream[] = data["data"] !== undefined ? data["data"] : data;

    for(let i = 0; i < dataToCheck.length; i++){
      let element = dataToCheck[i];
      let targetUser : User = undefined;

      if (element.user !== undefined){
        targetUser = element.user;
      }else{
        let res = await this.service.findOne({
          where: {
            id: element.id,
            deleted: false
          },
          relations: ["user"]
        });
        if(res === null){
          throw new UnauthorizedException();
        }
        targetUser = res.user;
      }

      if (userType == UserType.USER){
        if (targetUser.id !== user.sub) throw new UnauthorizedException();
      }

      if (userType == UserType.RESEARCHER){
        if (targetUser.organization.id !== user.organization) throw new UnauthorizedException();
      }
    }

    return data;
  }

  @Override()
  @Roles(UserType.ADMIN, UserType.RESEARCHER, UserType.USER)
  async getOne(@ParsedRequest() req: CrudRequest, @AuthUser() user: any): Promise<Dream> {
    let data = await this.base.getOneBase(req);
    let userType = user.type;

    if (userType == UserType.ADMIN) return data;
    
    let targetUser : User = undefined;

    if (data.user !== undefined){
      targetUser = data.user;
    }else{
      let res = await this.service.findOne({
        where: {
          id: data.id,
          deleted: false
        },
        relations: ["user"]
      });
      if(res === null){
        throw new UnauthorizedException();
      }
      targetUser = res.user;
    }

    if (userType == UserType.USER){
      if (targetUser.id !== user.sub) throw new UnauthorizedException();
    }

    if (userType == UserType.RESEARCHER){
      if (targetUser.organization.id !== user.organization) throw new UnauthorizedException();
    }

    return data;
  }

  @Override()
  @Roles(UserType.ADMIN, UserType.RESEARCHER, UserType.USER)
  @ProtectCreate(CreateType.SINGLE)
  async createOne(@ParsedRequest() req: CrudRequest, @ParsedBody() dto: Dream): Promise<Dream> {
    return this.base.createOneBase(req, dto);
  }

  @Override()
  @Roles(UserType.ADMIN, UserType.RESEARCHER, UserType.USER)
  @ProtectCreate(CreateType.BULK)
  async createMany(@ParsedRequest() req: CrudRequest, @ParsedBody() dto: CreateManyDto<Dream>): Promise<Dream[]> {
    return this.base.createManyBase(req, dto);
  }

  @Override()
  @Roles(UserType.ADMIN, UserType.RESEARCHER)
  @ProtectAlter()
  async updateOne(@ParsedRequest() req: CrudRequest, @ParsedBody() dto: Dream): Promise<Dream> {
    return this.base.updateOneBase(req, dto);
  }

  @Override()
  @Roles(UserType.ADMIN, UserType.RESEARCHER)
  @ProtectAlter()
  async replaceOne(@ParsedRequest() req: CrudRequest, @ParsedBody() dto: Dream): Promise<Dream> {
    return this.base.replaceOneBase(req, dto);
  }

  @Override()
  @Roles(UserType.ADMIN, UserType.RESEARCHER)
  @ProtectDelete()
  async deleteOne(@ParsedRequest() req: CrudRequest): Promise<void | Dream> {
    return this.base.deleteOneBase(req);
  }
}
