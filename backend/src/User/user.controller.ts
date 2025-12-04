import {
  Controller,
  Get,
  StreamableFile,
  Response,
  Post,
  Body,
  UnauthorizedException,
} from "@nestjs/common";
import { ApiSecurity, ApiTags } from "@nestjs/swagger";
import { CreateManyDto, Crud, CrudController, CrudRequest, GetManyDefaultResponse, Override, ParsedBody, ParsedRequest } from "@nestjsx/crud";
import { User } from "src/entities/user.entity";
import { UserService } from "./user.service";
import { AuthUser, Public } from "src/Auth/auth.decorator";
import { CreateType, ProtectAlter, ProtectCreateUser, ProtectDelete, Roles } from "src/Auth/roles.decorator";
import { DownloadDto } from "./DTO/download.dto";
import { UserType } from "src/entities/user_type.enum";

@Crud({
  model: {
    type: User,
  },
  query: {
    join: {
      dreams: {},
      psqis: {},
      chronotypes: {},
      organization: {eager:true}
    },
  },
})
@ApiTags("User")
@ApiSecurity("bearer")
@Controller("user")
export class UserController implements CrudController<User> {
  constructor(public service: UserService) {}

  get base(): CrudController<User> {
    return this;
  }

  @Override()
  @Roles(UserType.ADMIN, UserType.RESEARCHER)
  async getMany(@ParsedRequest() req: CrudRequest, @AuthUser() user : any): Promise<GetManyDefaultResponse<User> | User[]> {
    let data = await this.base.getManyBase(req);
    let userType = user.type;

    if (userType == UserType.ADMIN) return data;
    
    let dataToCheck : User[] = data["data"] !== undefined ? data["data"] : data;

    for(let i = 0; i < dataToCheck.length; i++){
      let element = dataToCheck[i];

      if (userType == UserType.RESEARCHER){
        if (element.organization.id !== user.organization) throw new UnauthorizedException();
      }
    }

    return data;
  }

  @Override()
  @Roles(UserType.ADMIN, UserType.RESEARCHER, UserType.USER)
  async getOne(@ParsedRequest() req: CrudRequest, @AuthUser() user : any): Promise<User> {
    if(user.type === UserType.USER || user.type === UserType.RESEARCHER){
      let requestedId = req.parsed.paramsFilter[0].value;
      let targetUser = await this.service.findOne({
        where: {
          id: requestedId,
          deleted: false
        }
      });
      
      if(targetUser === undefined){
        throw new UnauthorizedException();
      }
      
      if(user.type === UserType.USER && targetUser.id !== user.sub){
        throw new UnauthorizedException();
      }

      if(user.type === UserType.RESEARCHER && targetUser.organization.id !== user.organization){
        throw new UnauthorizedException();
      }      
      
    }
    return this.base.getOneBase(req);
  }

  @Override()
  @Roles(UserType.ADMIN, UserType.RESEARCHER)
  @ProtectCreateUser(CreateType.SINGLE)
  async createOne(@ParsedRequest() req: CrudRequest, @ParsedBody() dto: User): Promise<User> {
    return this.base.createOneBase(req, dto);
  }
  
  @Override()
  @Roles(UserType.ADMIN, UserType.RESEARCHER)
  @ProtectCreateUser(CreateType.BULK)
  async createMany(@ParsedRequest() req: CrudRequest, @ParsedBody() dto: CreateManyDto<User>): Promise<User[]> {
    return this.base.createManyBase(req, dto);
  }

  @Override()
  @Roles(UserType.ADMIN, UserType.RESEARCHER, UserType.USER)
  @ProtectAlter()
  async updateOne(@ParsedRequest() req: CrudRequest, @ParsedBody() dto: User): Promise<User> {
    return this.base.updateOneBase(req, dto);
  }
  
  @Override()
  @ProtectAlter()
  @Roles(UserType.ADMIN, UserType.RESEARCHER)
  async replaceOne(@ParsedRequest() req: CrudRequest, @ParsedBody() dto: User): Promise<User> {
    return this.base.replaceOneBase(req, dto);
  }

  @Override()
  @Roles(UserType.ADMIN, UserType.RESEARCHER)
  @ProtectDelete()
  async deleteOne(@ParsedRequest() req: CrudRequest): Promise<void | User> {
    return this.base.deleteOneBase(req);
  }



  // @Public()
  @Roles(UserType.ADMIN, UserType.RESEARCHER)
  @Post("/download")
  async downloadDreams(
    @Body() downloadDTO: DownloadDto,
    @Response({ passthrough: true }) res,
    @AuthUser() user: any
  ) {
    if(user.type === UserType.RESEARCHER){
      if(user.organization !== downloadDTO.organizationId){
        throw new UnauthorizedException();
      }
    }
    res.set({
      "Content-Type": "application/zip",
      "Content-Disposition": 'attachment; filename="dreamsdump.zip"',
    });
    return new StreamableFile(
      await this.service.downloadDreams(downloadDTO.organizationId)
    );
  }
}
