package com.fastrender.CacheWebsite.Model;

import lombok.*;

import java.io.Serializable;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@ToString
public class WebsiteData implements Serializable {
    private String url;
}
