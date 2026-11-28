library UserExtraData requires User

  struct UserExtraData extends array

    static method new takes player p returns thistype
      local thistype this = GetPlayerId(p)
      return this
    endmethod

  endstruct

endlibrary