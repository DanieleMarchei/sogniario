import { SetMetadata } from '@nestjs/common';
import { UserType } from '../entities/user_type.enum';

export const ROLES_KEY = 'roles';
export const Roles = (...roles: UserType[]) => SetMetadata(ROLES_KEY, roles);

export enum CreateType {
    SINGLE = 0,
    BULK = 1
}

export const PROTECT_CREATE_KEY = 'create';
export const ProtectCreate = (createType : CreateType) => SetMetadata(PROTECT_CREATE_KEY, createType);

export const PROTECT_CREATE_USER_KEY = 'createUser';
export const ProtectCreateUser = (createType : CreateType) => SetMetadata(PROTECT_CREATE_USER_KEY, createType);

export const PROTECT_DELETE_KEY = 'delete';
export const ProtectDelete = () => SetMetadata(PROTECT_DELETE_KEY, true);

export const PROTECT_ALTER_KEY = 'alter';
export const ProtectAlter = () => SetMetadata(PROTECT_ALTER_KEY, true);